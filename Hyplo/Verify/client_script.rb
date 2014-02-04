unless data['url'].nil?
  @browser.goto(data['url'])
	  if @chained
		  self.start("Hyplo/AddListing")
	  end
else
  if @chained
    self.start("Hyplo/Verify", 1440)
  end
end
self.success
