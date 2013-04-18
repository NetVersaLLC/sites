#Create an account
def create_new_account( data )
	@browser.link(:text => 'Sign up for an account').click
	@browser.text_field(:name => 'emailAddress').set data[ 'email' ] 
	captcha_text = solve_captcha
	@browser.text_field(:name => 'recaptcha_response_field').set captcha_text
	@browser.button(:type => 'submit').click
	if @browser.html.include?('A link to activate your account has just been emailed')
		puts "Email has sent for verification"
	else
		throw("Initial sign up got failed")
	end
end

def sign_out()
@sign_out = @browser.link(:text,'log out')
@sign_out.click if @sign_out.exist?
end

@url = 'www.craigslist.com'
begin
@browser.goto(@url)
@preferred_city = @browser.link(:text => "#{data[ 'preferred_city' ]}")
@preferred_city.click if @preferred_city.exist?
@browser.link(:text => 'my account').click

#Check for existing session
sign_out()
#Create a new account
create_new_account( data )

if @chained
  self.start("Craig_list/Verify")
end

rescue Exception => e
  puts("Exception Caught in Business Listing")
  puts(e)
end




