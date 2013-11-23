@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

retries = 5

begin
	@browser.goto("https://listings.mapquest.com/apps/listing")
	@browser.text_field(:name, "firstName").when_present.set data['fname']
	@browser.text_field(:name, "lastName").set data['lname']
	@browser.text_field(:name, "phone").set data['phone']
	@browser.text_field(:name, "email").set data['email']
	@browser.span(:class => "btn-var-inner", :text => "Create an Account").click
	Watir::Wait.until { @browser.text.include? "You're Almost Done" } 
	if @chained == true
		self.start("Mapquest/Verify")
	end
	self.save_account("MapQuest", {:email => data['email']})
	true
rescue => e
  unless retries == 0
    puts "Error caught while signing up: #{e.inspect}"
    puts "Retrying in two seconds. #{retries} attempts remaining."
    sleep 2
    retries -= 1
    retry
  else
    raise "Error while signing up could not be resolved. Error: #{e.inspect}"
  end
end