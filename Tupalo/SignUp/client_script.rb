#Enter your email address to register
url="http://tupalo.com/en/accounts/sign_up"
@browser.goto(url)

@browser.text_field(:id => /account_email/).set data['email']
@browser.button(:name => /commit/).click

sleep 2 
Watir::Wait::until {@browser.text.include? "My Favorites"}

self.save_account("Tupalo", {:username => data[ 'username' ], :password => data[ 'password' ], :email => data[ 'email' ]})

if @chained
	self.start("Tupalo/Verify")
end
true