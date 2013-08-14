#Activate the account and set the password for the account.
password = data[ 'pass' ]

url="http://tupalo.com/en/accounts/sign_in"
@browser.goto(url)

sleep 2
Watir::Wait::until {@browser.text.include? "Login"}

@browser.text_field(:id => "account_email").set data ['email']
@browser.text_field(:id => "account_password").set password
@browser.button(:id => "spot_submit").click

sleep 2
Watir::Wait::until {@browser.text.include? "My Favorites"}

@browser.goto("http://tupalo.com/en/user/settings/password")
sleep 2
Watir::Wait::until {@browser.text.include? "Account Settings"}

#Set the password for the account.
@browser.text_field(:id => "password_old").set password
@browser.text_field(:id => "user_password").set data['password']

@browser.button(:value => "Save New Password").click

sleep 2
Watir::Wait::until {@browser.text.include? "My Favorites"}


if @chained
	self.start("Tupalo/AddListing")
end

true