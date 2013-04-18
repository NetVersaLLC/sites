@browser.goto(data['url'])

if @browser.text.include? "Your account has been activated. To gain access to the business you are trying to claim, you must now login below using your email address and recently created password."

	puts( "Successfully verified." )
	
	if @chained
		self.start("Yellowise/CreateListing")
	end
	true

end

