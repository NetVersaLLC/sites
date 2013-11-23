@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

#Enter your email address to register
url="http://tupalo.com/en/accounts/sign_up"
@browser.goto(url)

@browser.text_field(:id => /account_email/).set data['email']
@browser.button(:name => /commit/).click

30.times{ break if @browser.status == "Done"; sleep 1}

self.save_account("Tupalo", {:username => data[ 'email' ], :password => data[ 'password' ], :email => data[ 'email' ]})

if @chained
	self.start("Tupalo/Verify")
end
true