def process_crunchbase_signup(profile)
	puts 'Sign up for new Crunchbase account'

  @browser.text_field(:id, "user_name").set profile['name']
  @browser.text_field(:id, "user_username").set profile['username']
  @browser.text_field(:id, "user_password").set profile['password']
  @browser.text_field(:id, "user_password_confirmation").set profile['password']
  @browser.text_field(:id, "user_email_address").set profile['email']
  
    @browser.text_field(:id, "user_twitter_username").set profile['twitter']
  @browser.text_field(:id, "user_homepage_url").set profile['homepage']

  enter_captcha 

  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => profile[ 'username' ], 'account[password]' => profile[ 'password' ], 'model' => 'Crunchbase'
  Watir::Wait.until {@browser.text.include? 'Connect with Facebook' }
  if profile['use_facebook'] == true
    @browser.div(:id => "facebook_link_holder").img(:index => 0).click
  else
    @browser.link(:text => /Skip this step/).click
  end

	puts 'Signup is Completed'
	
end
goto_signup_page
process_crunchbase_signup(data)
true