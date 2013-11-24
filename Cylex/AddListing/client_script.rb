@browser = Watir::Browser.new :firefox

at_exit {
	unless @browser.nil?
		@browser.close
	end
}

# Temporary methods copied from Shared.rb

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\cylex_captcha.png"
  obj = @browser.image(:src, /randomimage/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def enter_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha  
    @browser.text_field(:id => /step1_captchaTb/).set captcha_code
    sleep 10
    @browser.text_field(:name => /companypass1/).set data['password']
    @browser.text_field(:name => /companypass2/).set data['password']
    @browser.button(:value => 'Next step').click
    sleep(5)
    if not @browser.text.include? "Incorrect validation code, please try again"
      capSolved = true
    end
    count+=1
  end
  if capSolved == true
    true
  else
    throw "Captcha was not solved"
  end
end

def fill_map_routing(data)
  @browser.link(:text => /Company details/).click
  @browser.text_field(:name => /companyname/).set data['business']
  @browser.text_field(:name => /companystreet/).set data['address']
  @browser.text_field(:name => /companycity/).set data['city']
  sleep(4)
  @browser.text_field(:name => /postnr/).set data['zip']
  @browser.text_field(:name => /companyweb/).set data['website']
  @browser.text_field(:name => /companymail/).set data['email']
  @browser.text_field(:id => "p_scnt_phone").set data['phone']
  @browser.text_field(:id => "p_scnt_fax").set data['fax']
=begin
  unless self.logo.nil? 
    @browser.file_field(:name => /FileUpload1/).set self.logo
    @browser.button(:value => "Upload").click
  else
    @browser.file_field(:name => /FileUpload1/).set self.images.first unless self.images.empty?
    @browser.button(:value => "Upload").click
  end
=end

  @browser.button(:id => /modifybasicinfo_save/).click
  Watir::Wait.until { @browser.text.include? "Saving was successful." }
  @browser.link(:id => /home/).click
end

def fill_payment_methods(data)
  @browser.link(:text => /Payment methods/).click

  payment_methods = { "13" => "cash", "2" => "check", "14" => "mastercard", "16" => "visa", "4" => "discover", "8" => "diners", "12" => "amex", "15" => "paypal" }

  payment_methods.each do |key, method|
    @browser.div(:class => /block-content/).ul.lis.each do |list_item|
      list_item.input.click if list_item.input.attribute_value("checked") == "true"
    end
  end

  payment_methods.each do |key, method|
    @browser.div(:class => /block-content/).ul.li(:index => key.to_i).input.click if data[method]
  end
  @browser.button(:value => 'Save').click
  15.times { break if @browser.status == "Done"; sleep 1 }
  @browser.link(:id => /home/).click
end

# End temporary methods copied from shared.rb

def search_result(data)
  @browser.text_field(:name => /companyname/).set data['business']
  @browser.text_field(:name => /city/).set data['city']
  sleep 1
  if @browser.link(:text, /data['state']/).present?
  	@browser.link(:text, /data['state']/).click
  end
  @browser.text_field(:name => /website/).set data['website']
  @browser.button(:value => 'Check name').click
  # @browser.wait()
  15.times { break if @browser.status == "Done"; sleep 1 }
end

def add_new_business(data)
  @browser.link(:text => 'Add Company').click
  @browser.text_field(:name => /companyname/).set data['business']
  #Password is set during captcha solve
  @browser.text_field(:name => /companystreet/).set data['address']
  @browser.text_field(:name => /companycity/).set data['city']
  sleep(4)
  @browser.link(:xpath => '//*[@id="ctl00_bodyadmin"]/ul[2]/li/a').when_present.click
  @browser.text_field(:name => /postnr/).set data['zip']
  @browser.text_field(:name => /companymail/).set data['email']
  @browser.text_field(:id => /p_scnt_phone/).set data['phone']
  @browser.checkbox(:name => /cbaccept/).set

  # Enter Captcha Code
  enter_captcha(data)
  # Check for error
  # error_msg = @browser.span(:class => 'message error no-margin')
  # if @error_msg.exist?
  #   puts "Showing error message saying #{@error_msg.text}"
  # end
  # Step 2
  @browser.textarea(:name => /tb_keywords/).when_present.set data['keywords']
  @browser.textarea(:name => /tb_shortdesc/).set data['business_description']
  @browser.button(:value => 'Save').click
  
  # Check for confirmation
  unless @browser.span(:id => /lb_profstatus/).text.include? "Profile complete:"
    throw "Initial Business registration is Unsuccessful"
  end

  puts "Initial Business registration is successful"
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Cylex'

  # Filling rest of information.
  @browser.send_keys :f5

  fill_map_routing data
  fill_payment_methods data
  return true
end

def search_company(data)
  @business_found = false
  
  if @browser.table(:id => /companynamechecking_gv_companies/).exist?
    @table = @browser.table(:id => /companynamechecking_gv_companies/)
    @table.rows.each do |row|
      if row[1].text == data['business']
        puts "Claiming the business"
        row.link(:text => 'This is my company').click
        @business_found = true
        break
      end
    end
  end
  return @business_found
end

def claim_business(data)
  @browser.radio(:value => "#{data['role']}").set
  @browser.text_field(:name => /companyname/).set data['business']
  @browser.text_field(:name => /companystreet/).set data['address']
  @browser.text_field(:name => /companycity/).set data['city']
  @browser.text_field(:name => /postnr/).set data['zip']
  @browser.select_list(:name => /state2/).select data['state']
  @browser.text_field(:name => /companyphone/).set data['phone']
  @browser.text_field(:name => /companyweb/).set data['website']
  @browser.text_field(:name => /companymail/).set data['email']
  @browser.text_field(:name => /tb_keywords/).set data['keywords']
  @browser.text_field(:name => /tb_shortdesc/).set data['business_description']
  rolewise_info_update(data)
  @browser.text_field(:name => /captchaTb/).set captcha
  @browser.button(:value => 'Save changes').click
  
  #Check for confirmation
  @success_text ="Thank you for updating the company presentation page! "
  
  if @browser.span(:id => /registered_infotext/).text.include?(@success_text)
    puts "Business has been claimed successful"
  else
    throw "Business has not been claimed successful"
  end
end

def rolewise_info_update(data)
  if data['role'] == 'owner'
    @browser.text_field(:id => /tb_complain/).set data['reason_for_info_update']
    @browser.select_list(:name => /ddltitle/).select data['name_title']
    @browser.text_field(:id => /owner_firstname/).set data['first_name']
    @browser.text_field(:id => /owner_surname/).set data['last_name']
    @browser.text_field(:id => /ddldept/).set data['department']
    @browser.text_field(:id => /owner_email/).set data['email']
  elsif data['role'] == 'visitor'
    @browser.text_field(:id => /tb_complain/).set data['reason_for_info_update']
    @browser.text_field(:id => /owner_firstname/).set data['first_name']
    @browser.text_field(:id => /owner_surname/).set data['last_name']
  end
end
    
# Main Steps
# Launch browser
@url = 'http://admin.cylex-usa.com/firma_default.aspx?step=0&d=cylex-usa.com'
@browser.goto(@url)

# Search for Business

search_result(data)
if search_company(data)
  claim_business(data)
else
  add_new_business(data)
  true
end