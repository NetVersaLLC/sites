@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def find_listing(data)
  @browser.goto "http://www.mywebyellow.com/"

  @browser.text_field(:id => "ctl00_ContentPlaceHolder01_SearchOptions01_fldSearch").set data['bu_name']
  @browser.text_field(:id => "ctl00_ContentPlaceHolder01_SearchOptions01_fldLocation").set data['zip']
  @browser.button(:id => "ctl00_ContentPlaceHolder01_SearchOptions01_butSearch").click

  links = @browser.links(:class => "Link01")

  return nil if links.length == 0 || !links.first.text.include?(data['bu_name'])

  links.first.click
  @browser.url
end 


def fillout_fields( data )
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldContactName').set data['pe_name']
    unless data['pe_phone'].nil?
    	@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldContactPhone').set data['pe_phone']
    else
    	@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldContactPhone').set data['bu_phone']
    end
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldContactEmail').set data['bu_email']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldContactBestTime').set data['bt_call']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldContactComments').set data['comment']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBusinessName').set data['bu_name']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldAddress').set data['address']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldCity').set data['city']
    @browser.select_list( :id, 'ctl00_ContentPlaceHolder01_fldState').select data['state']
    sleep(1)
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldZip').set data['zip']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldPhone').set data['bu_phone']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldPhoneTollFree').set data['toll_phone']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldFax').set data['fax']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldEmail').set data['c_email']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldDescription').set data['description']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBrands').set data['bp_represent']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldTagLine').set data['tag']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBullet01').set data['item1']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBullet02').set data['item2']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBullet03').set data['item3']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBullet04').set data['item4']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBullet05').set data['item5']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldBullet06').set data['item6']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldHours01').set data['h_line1']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldHours02').set data['h_line2']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldHours03').set data['h_line3']
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldHours04').set data['h_line4']

    data[ 'payments' ].each{ | pay |
        @browser.checkbox( :id => pay ).click
      }
    @browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkURL').set data['url']

    5.times do 
      @browser.text_field( :id, /CaptchaEntry/ ).set solve_captcha
      @browser.button( :id, 'ctl00_ContentPlaceHolder01_imgSubmit').click

      Watir::Wait.until do 
        @browser.span(:text => /has been submitted/).exist? || 
        @browser.span(:text => /Captcha image are invalid/).exist? 
      end 
      break if @browser.span(:text => /has been submitted/).exist?
    end
    @browser.span(:text => /has been submitted/).exist?
end

def upload_logo( data )
    unless self.logo.nil?  
    	@browser.file_field(:name,"ctl00$ContentPlaceHolder01$fldLogoNew").set self.logo
    end
    sleep (1)
end


def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\mywebyellow_captcha.png"
  obj = @browser.image( :id, /Captcha01_img/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image
end


listing_url = find_listing(data)

if listing_url 
  self.save_account("Mywebyellow", {:listing_url => listing_url}) 
  @browser.goto listing_url 
  @browser.link(:text => /Correct Listing/).click 
  @browser.span(:text => /existing listing/).wait_until_present
else 
  @browser.goto "http://www.mywebyellow.com/AddListing.aspx" 
  @browser.span(:text => /new listing/).wait_until_present
end

if fillout_fields( data )
  self.save_account("Mywebyellow", {:status => "Listing updated sucessfully"})
  if listing_url.nil? && @chained 
    self.start("Mywebyellow/Verify", 60 * 24 )
  end 
  self.success
else 
  self.failure("Captcha failure")
end
