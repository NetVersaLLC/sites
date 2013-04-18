@url = 'http://www.business.com/company/create/'
  @browser.goto(@url)

  #Fill form on Step -I
  @browser.link(:text,'Create my FREE company profile').click
  @browser.text_field(:id => 'Member_first_name').set data[ 'first_name' ]
  @browser.text_field(:id => 'Member_last_name').set data ['last_name']
  @browser.text_field(:id => 'Member_title').set data ['title']
  @browser.text_field(:id => 'User_email').set data ['email']
  @browser.text_field(:id => 'email2').set data ['email']
  @browser.text_field(:id => 'User_password').set data ['password']
  @browser.text_field(:id => 'password2').set data ['password']

  def captcha
    #ToDo : Captcha Code
    return captcha_text
  end

  #Enter Decrypted captcha string here
  captcha_text = solve_captcha()
  @browser.text_field(:id => 'User_verifyCode').set captcha_text 


  @browser.button(:type,'submit').click
  #Check the error
  @validation_error = @browser.div(:class,'error errorSummary')
  if @validation_error.exist?
    throw("Throwing Error while Signup: #{@validation_error}")
  else
    puts "Steps I successfully passed"
  end
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Businesscom'

  #Fill last form page
  @browser.text_field(:id => 'Company_name').set data['company_name']
  @browser.text_field(:id => 'CompanyAddress_street_1').set data['address']
  @browser.text_field(:id => 'CompanyAddress_city').set data['city']
  @browser.select_list(:id => 'CompanyAddress_state').select data['state']
  @browser.text_field(:id => 'CompanyAddress_zip').set data['zip']
  @browser.text_field(:id => 'Company_phone').set data ['phone']
  @browser.text_field(:id => 'Company_url').set data ['company_url']
  @browser.text_field(:id => 'Company_description').set data['description']
  @browser.select_list(:id => 'CompanyAdditionalInfo_company_type').select data['company_type']
  @browser.select_list(:id => 'CompanyAdditionalInfo_employees').select data['no_of_employees']
  @browser.select_list(:id => 'CompanyAdditionalInfo_annual_sales').select data['annua_sales']
  @browser.text_field(:id => 'CompanyAdditionalInfo_yrs_in_business').set data['years_in_business']
  @browser.select_list(:id => 'CompanyAdditionalInfo_sqft').select data['office_footage']
  @browser.select_list(:name => 'category').select data['category']
  @browser.select_list(:name => 'tail').when_present.select data['sub_category']
  @browser.button(:type,'submit').click

  #Check for error message
  @success_msg =  @browser.div(:class,'simplemodal-data')
  @success_text = 'Thank you for completing your Business.com company profile'

  if @validation_error.visible?
    throw("Throwing Error while Signup: #{@validation_error}")
  elsif @success_msg.exist? && @success_msg.text.include?(@success_text)
    puts "Business registered Successfully"
  end

  #Click on 'Close' link
  @browser.link(:text => 'Close').click
