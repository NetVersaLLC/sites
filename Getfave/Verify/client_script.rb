link = data['link']
@browser.goto(link)
30.times{ break if @browser.status == "Done"; sleep 1}
if @browser.text.include? "Log Out"
	if @chained
  		self.start("Getfave/CreateListing")
	end
  	true
else
	puts "Error while email verification"
end