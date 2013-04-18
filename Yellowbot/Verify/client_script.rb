
@browser.goto(data['url'])
@browser.text_field( :name => 'login').set data['email']
@browser.text_field( :name => 'password').set data['password']
@browser.button( :name => 'subbtn').click
sleep(5)

if @chained
	  self.start("Yellowbot/CheckListing")
	end

true