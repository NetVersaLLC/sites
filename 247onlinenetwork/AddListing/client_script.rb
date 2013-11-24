def addlisting(data)
	tries ||= 5
	@browser.goto 'http://www.247onlinenetwork.com/freelisting.php'
	@browser.select_list.select("Mr.")
	@browser.text_field(:id, "firstname").set data['firstname']
	@browser.text_field(:id, "surname").set data['lastname']
	@browser.text_field(:id, "busphone").set data['phone']
	@browser.text_field(:id, "busemail").set data['email']
	@browser.button(:value,"Next >>").click
	@browser.text_field(:id, "busname").set data['business_name']
	@browser.text_field(:id, "address").set data['address']
	@browser.text_field(:id, "city").set data['city']
	@browser.text_field(:id, "state").set data['state']
	@browser.text_field(:id, "country").set("United States")
	@browser.text_field(:id, "zip").set data['zip']
	@browser.text_field(:id, "website").set data['website']
	@browser.button(:value,"Next >>").click
	@browser.area(:id, "busdesc").set data['business_description']
	@browser.area(:id, "listingcontent").set data['business_description']
	@browser.button(:value,"Next >>").click
	@browser.select_list(:id, "q2").select("Salesperson")
	@browser.select_list(:id, "q1").select("Yes")
	@browser.select_list(:id, "q3").select("Exposure across a larger geographic region")
	@browser.button(:value,"Next >>").click
	@browser.button(:value,"Finish").click
	@browser.link(:text, "click to continue").click
rescue => e
	if (tries -= 1) > 0
		puts "247onlinenetwork/AddListing failed. Retrying #{tries} more times."
		puts "Details: #{e.message}"
		sleep 2
		retry
	else
		puts "247onlinenetwork/AddListing failed. Out of retries. Quitting."
		raise e
	end
else
	puts "247onlinenetwork/AddListing succeeded!"
	true
end

@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

addlisting data