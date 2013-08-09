link = data['link']
if link.nil? then
	if @chained
		self.start("Facebook/Verify", 1440)
	end
end

@browser.goto(link)
sleep 4
if @browser.text.include? "Enter"
	retry_verify_captcha(data)
	sleep(3)
elsif @browser.text.include? "Please Verify Your Identity"
	if @chained
		self.start("Facebook/Notify")
		true
	end
end
if @browser.button(:value =>'Find Friends').exist?
  puts "Mail verification is successfull"
else
  puts "Main verification got some error"
end

if @chained
  self.start("Facebook/CreatePage")
  true
end