@url = 'https://www.thumbtack.com/register'
  @browser.goto(@url)
  
@browser.text_field(:id => 'usr_first_name').set data['first_name']
@browser.text_field(:id => 'usr_last_name').set data['last_name']
@browser.text_field(:id => 'usr_email').set data['email']
@browser.text_field(:id => 'usr_password').set data['password']
@browser.link(:text => /Join/i).click

Watir::Wait.until { @browser.text.include? "Please verify your email address" }

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Thumbtack'

if @chained
  self.start("Thumbtack/Verify")
end

true



=begin

  @browser.text_field(:name => 'sav_business_name').when_present.set data ['business']
  @browser.text_field(:name => 'phone_number').set data ['phone']
  @browser.text_field(:name => 'website').set data ['website']
  @browser.text_field(:name => 'sav_description').set data ['description']
  @browser.text_field(:name => 'sav_title').set data ['title']
  @browser.text_field(:name => 'usa_address1').set data ['address']
  @browser.text_field(:name => 'usa_zip_code_id').set data ['zip']
  @browser.checkbox(:value => 'tocustomer').set
  @browser.link(:text,/List my services/).click

  # Check for Error
  if @browser.div(:class,'form-error').visible?
    throw("Validation Fails : #{@browser.div(:class,'form-error').text}")
  end
sleep(2)
# Remove this line if we have a way to login via facebook
  @browser.link(:text,/Skip this step/).when_present.click

  ## No facebook password
  # Second Link
#  @browser.link(:href,/facebook/).when_present.click
#  sleep(15)
#  @browser_pop = Watir::Browser.attach(:title,'Log In | Facebook')
#  @browser_pop.text_field(:name => 'email').set data['facebook_id']
#  @browser_pop.text_field(:name => 'pass').set data ['facebook_password']
#  @browser_pop.button(:type,'submit').click
#  @browser_pop.button(:value,'Log In with Facebook').when_present.click
#  @browser_pop.button(:value,'Allow').click

  ## Image upload in Signup Manager isn't working
  # Third Step
  #@browser.link(:text,/Add pictures/).when_present.click
  #@browser.file_field(:name,'Filedata').set data['image']
  #sleep (10)
  #@browser.link(:text,/Continue/).when_present.click

  #remove this line if the image stuff is fixed.
 sleep (3)
  @browser.link(:text,/Skip this step/).when_present.click
 sleep (3)
  # Last Step
  if @browser.text.include? 'Check your email'
    puts "Initial Registration Successful"
	if @chained
	  self.start("Thumbtack/CreateListing")
	end
    true
  else
    throw("Initial Registration Unsuccessful")
  end
#  @browser.close

=end
