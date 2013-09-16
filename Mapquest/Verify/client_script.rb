retries = 5

puts("Caught Url: " + data['url'])
if data['url'].nil?
	self.start("Mapquest/Verify", 1440)
else
	begin
		@browser.goto(data['url'])
		if @browser.text.include? 'Account Activated!'
			@browser.text_field(:name, "pass1").set data['password']
			@browser.text_field(:name, "pass2").set data['password']
			@browser.span(:class => "btn-var-inner", :text => "Continue").click
			Watir::Wait.until { @browser.text.include? "Add a Business Listing" }
			if @chained == true
				self.start("Mapquest/AddListing")
			end
			self.save_account("MapQuest", {:password => data['password']})
			true
		end
	rescue => e
  		unless retries == 0
    		puts "Error caught in post-verification signup: #{e.inspect}"
    		puts "Retrying in two seconds. #{retries} attempts remaining."
    		sleep 2
    		retries -= 1
    		retry
  		else
    		raise "Error in post-verification signup could not be resolved. Error: #{e.inspect}"
  		end
	end
end