@browser.goto(data['url'])
sleep(10) #wait for the stupid auto redirect
if @browser.text.include? "Profile Manager"
	if @chained
		self.start("Zippro/Notify")
	end
	true

end
