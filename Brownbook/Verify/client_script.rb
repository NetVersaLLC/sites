# Retry Count
retries = 5

# Main Script
begin	
	if data['url'].nil?
		self.start("Brownbook/Verify", 1440)
	else
		@browser.goto("#{data['url']}")
		username = data['username'].split("@")[0]
		@browser.text_field(:id, "user_screen").when_present.set username
		@browser.text_field(:id, "password").set data['password']
		@browser.text_field(:id, "password2").set data['password']
		@browser.button(:id, "submits").click
		Watir::Wait.until { @browser.text.include? "Account Created" }
		self.save_account("Brownbook", { :password => data['password'] })
		if @chained
			self.start("Brownbook/Addlisting")
		end
		true
	end
rescue => e
  unless retries == 0
    puts "Error caught verifying business: #{e.inspect}"
    puts "Retrying in two seconds. #{retries} attempts remaining."
    sleep 2
    retries -= 1
    retry
  else
    raise "Error while verifying business could not be resolved. Error: #{e.inspect}"
  end
end