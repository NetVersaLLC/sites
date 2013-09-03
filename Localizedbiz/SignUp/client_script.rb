@browser.goto("http://localizedbiz.com/login/register.php")
30.times{ break if @browser.text_field( :id => 'username').exist?; sleep 1}
@browser.text_field( :id => 'username').set data['username']
@browser.text_field( :id => 'password').set data['password']
@browser.text_field( :id => 'password_confirmed').set data['password']
@browser.text_field( :id => 'email').set data['email']

@browser.button( :name => 'register').click

30.times{ break if @browser.text_field( :name => 'q').exist?; sleep 1}
if @browser.text.include? "The email you used is associated with another user. Please try again or use the \"forgot password\" feature!"
	puts "Email already registered."	
else
	self.save_account("Localizedbiz", {:username => data['username'], :password => data['password']})
	if @chained
		self.start("Localizedbiz/Verify")
	end	
end
true