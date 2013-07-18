if data['link'] == nil
	if @chained
		self.start("Localdatabase/Verify", 1440)
	end
	true
else
@browser.goto(data['link'])
true
end