#Method for add business
def add_new_business(data)
  #@browser.link(:text => 'Add your business').click
  @browser.text_field(:name => /BusinessName/).set data[ 'business']
  @browser.text_field(:name => /StreetAddress/).set data[ 'address']
  @browser.text_field(:name => /Suburb/).set data['city']
  @browser.text_field(:name => /Suburb/).send_keys :enter
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

  if @browser.text.include? "Your city and Zip code don't seem to match." then
  	@browser.text_field(:name => /Suburb/).set " " + data['city']
  	@browser.text_field(:name => /Suburb/).send_keys :enter
  	enter_captcha(data)
  end
 
  if @browser.text.include?("Thank you for joining Hotfrog")
    puts "Initial Registration is successful"
    self.save_account("Hotfrog", {:email => data['email'], :password => data['password']})
  else
    throw("Initial Registration is Unsuccessful")
  end
end

#Main Steps
# Launch browser

@url = 'http://www.hotfrog.com/AddYourBusinessSingle.aspx'
@browser.goto(@url)
#@browser.link(:text => 'Add your business').click
add_new_business(data)

if @chained == true
  self.start("Hotfrog/Verify")
end

true
