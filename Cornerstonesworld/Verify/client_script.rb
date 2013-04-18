@browser.goto(data['url'])

puts("waiting for email to arrive")
sleep(15)

if @chained
	self.start("Cornerstonesworld/GetUsername")
end

true
