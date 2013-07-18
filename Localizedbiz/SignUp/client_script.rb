@browser.goto("http://localizedbiz.com/login/register.php")
puts(data['username'])
@browser.text_field( :id => 'username').set data['username']
@browser.text_field( :id => 'password').set data['password']
@browser.text_field( :id => 'password_confirmed').set data['password']
@browser.text_field( :id => 'email').set data['email']

@browser.button( :name => 'register').click

if @browser.text.include? 'Account registered. Please check your email for details on how to activate it.'
self.save_account("Localizedbiz", {:username => data['username'], :password => data['password']})
	if @chained
		self.start("Localizedbiz/Verify")
	end
	true
end


