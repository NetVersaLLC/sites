#Method for add business
def add_new_business(data)
  @browser.link(:text => 'Add your business').click
  @browser.text_field(:name => /BusinessName/).set data[ 'business']
  @browser.text_field(:name => /StreetAddress/).set data[ 'address']
  @browser.text_field(:name => /Suburb/).set data[ 'city']
  @browser.text_field(:name => /Suburb/).send_keys :tab
  @browser.select_list(:name => /State/).option(:value => data['state']).select
  @browser.text_field(:name => /Postcode/).set data[ 'zip']
  @browser.text_field(:name => /Email/).set data[ 'email']
  @browser.text_field(:name => /Website/).set data[ 'website']
  @browser.text_field(:name => /Description/).set data[ 'business_description']
  @browser.text_field(:name => /Keywords/).set data[ 'keywords']
  @browser.link(:text=> 'Add keyword(s)').click
  @browser.text_field(:name => /FirstName/).set data[ 'first_name']
  @browser.text_field(:name => /LastName/).set data[ 'last_name']
  @browser.select_list(:name => /JobTitle/).select data[ 'job_title']
  @browser.text_field(:name => /AdminEmail/).set data[ 'email']
  @browser.text_field(:name => /txtPassword/).set data[ 'password']
  @browser.text_field(:name => /ConfirmPassword/).set data[ 'password']
  
  #Captcha Text
  enter_captcha(data)
 
  if @browser.text.include?("Thank you for joining Hotfrog")
    puts "Initial Registration is successful"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Hotfrog'
  else
    throw("Initial Registration is Unsuccessful")
  end
end

#Main Steps
# Launch browser
@browser = Watir::Browser.new
@url = 'http://www.hotfrog.com/'
@browser.goto(@url)
@browser.link(:text => 'Add your business').click
add_new_business(data)
