sign_in_business(data)

retries = 3
begin

	if retries < 3 
		@browser.goto("https://www.bingplaces.com/DashBoard")
	end
	@browser.link(:text => "Verify now").click
	sleep 2
	@browser.button(:value => 'Verify now', :class => "bigButton").when_present.click

	sleep 2
	@browser.button(:value => 'OK', :class => "bigButton").when_present.click
	true
rescue Exception => e
	puts(e.inspect)
	if retries > 0
		puts("Something went wrong while tring to Verify the account. Retrying in 2 seconds...")
		sleep
		retries -= 1
		retry
	else

	end
end