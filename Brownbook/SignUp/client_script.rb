# Retry Count
retries = 5

# Main Script
begin
	@browser.goto("http://www.brownbook.net/user/register/")
	@browser.text_field(:id, "email").when_present.set data['email']
	@browser.text_field(:id, "email2").when_present.set data['email']

	retry_captcha

	@browser.button(:id, "submits").click
	Watir::Wait.until { @browser.text.include? "Thanks for registering" }
	self.save_account("Brownbook", { :email => data['email'] })
	if @chained
		self.start("Brownbook/Verify") # Add 60 minute wait before pushing
	end
	true
rescue => e
  unless retries == 0
    puts "Error caught during signup: #{e.inspect}"
    puts "Retrying in two seconds. #{retries} attempts remaining."
    sleep 2
    retries -= 1
    retry
  else
    raise "Error caught during signup could not be resolved. Error: #{e.inspect}"
  end
end