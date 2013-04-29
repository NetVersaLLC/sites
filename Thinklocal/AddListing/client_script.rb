# Methd for Sign up
def sign_up(data)
  @browser.text_field(:id => /regEmail/).set data['email']
  @browser.text_field(:id => /regPass/).set data['password']
  @browser.text_field(:id => /confirmPass/).set data['password']
  @browser.text_field(:id => /firstName/).set data['first_name']
  @browser.text_field(:id => /lastName/).set data['last_name']
  @browser.text_field(:id => /areaCode/).set data['phone_area']
  @browser.text_field(:id => /prefix/).set data['phone_prefix']
  @browser.text_field(:id => /extention/).set data['phone_suffix']
  @browser.text_field(:id => /BusinessName/).set data['business']
  @browser.text_field(:id => /FullAddress/).set data['address']
  @browser.text_field(:id => /City/).set data['city']
  @browser.select_list(:id => /State/).select data['state']
  @browser.text_field(:id => /Zip/).set data['zip']
  @browser.text_field(:id => /PhoneA/).set data['phone_area']
  @browser.text_field(:id => /PhoneB/).set data['phone_prefix']
  @browser.text_field(:id => /PhoneC/).set data['phone_suffix']
  @browser.text_field(:id => /WebAddress/).set data['website']

  data['payments'].each do |pay|
    @browser.checkbox(:id => /#{pay}/).set
  end
  @browser.select_list(:name => /CategoryTop/).select data[ 'category' ]
  sleep(3)
  @browser.select_list(:name => /CategoryOne/).select data[ 'sub_category' ]
  sleep(2)
  @browser.button(:id => /btnCategoryOneSelect/).click
  @browser.checkbox(:id => /agree/).set
  @browser.button(:id => /btnSignUp/).click
  if @browser.text.include?('Account Manager')
    puts "Initial registration is Successful"
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Thinklocal'
  elsif @browser.div(:id => /ValidationSummary1/).enabled?
	  puts "Initial registration is Unsuccessful"
  end
end

# Main steps
@url = 'http://www.thinklocal.com/Business-Signup.aspx'

@browser.goto(@url)
sign_up(data)
