@browser.goto("http://localizedbiz.com/login/register.php")
30.times{break if (begin @browser.text_field(:name, "email").present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}
@browser.text_field( :id => 'username').set data['username']
@browser.text_field( :id => 'password').set data['password']
@browser.text_field( :id => 'password_confirmed').set data['password']
@browser.text_field( :id => 'email').set data['email']

@browser.button( :name => 'register').click

30.times{break if (begin @browser.text.include?("Account registered. Please check your email for details on how to activate it.") rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1}

self.save_account("Localizedbiz", {:username => data['username'], :password => data['password']})
if @chained
	self.start("Localizedbiz/Verify")
end
true