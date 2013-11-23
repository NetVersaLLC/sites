@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\mywebyellow_captcha.png"
  obj = @browser.image( :id, /Captcha01_img/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha( data )
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha
		@browser.text_field( :id, /CaptchaEntry/ ).set captcha_code
		@browser.button( :id, 'ctl00_ContentPlaceHolder01_imgSubmit').click

		30.times{ break if @browser.status == "Done"; sleep 1}
		
		if not @browser.text.include? "The characters you entered for the Captcha image are invalid."
			capSolved = true
		end
		
	count+=1	
	end
	if capSolved == true
		Watir::Wait.until { @browser.text.include? "Your information has been submitted" }
		true
	else
		throw("Captcha was not solved")
	end
end


#TODO: Rewrite this so that it's cleaner
@browser.goto('http://www.mywebyellow.com/AddListing.aspx')
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

unless self.logo.nil?  
	@browser.file_field(:name,"ctl00$ContentPlaceHolder01$fldLogoNew").set self.logo
end
sleep (1)
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkURL').set data['url']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkMenu').set data['menu']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkECommerce').set data['e_cs']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkCoupon').set data['coupon']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkYouTube').set data['yt_emblink']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkFacebook').set data['facebook']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkLinkedIn').set data['linkedin']
@browser.text_field( :name, 'ctl00$ContentPlaceHolder01$fldLinkTwitter').set data['twitter']
sleep(1)

enter_captcha(data)