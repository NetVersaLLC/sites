url="http://tupalo.com/en/accounts/sign_in"
@browser.goto(url)

sleep 2
Watir::Wait::until {@browser.text.include? "Login"}

@browser.text_field(:id => "account_email").set data ['email']
@browser.text_field(:id => "account_password").set data['password']
@browser.button(:id => "spot_submit").click

sleep 2
Watir::Wait::until {@browser.text.include? "My Favorites"}

url=@browser.url+"?only=discovered_spots"
@browser.goto(url)

sleep 2
Watir::Wait::until {@browser.text.include? "My Discoveries"}

@browser.span(:class => "index" ).click

sleep 2
Watir::Wait::until {@browser.text.include? "Category:"}

url=@browser.a(:text => /Claim your business listing/).href
@browser.goto(url)

sleep 2
Watir::Wait::until {@browser.text.include? "Promote your business"}

@browser.a(:class => /button green color/).click
sleep 2
true