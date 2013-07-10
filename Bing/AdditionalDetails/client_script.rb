sign_in_business( data )
sleep 2
Watir::Wait.until { @browser.text.include? "All Businesses" }

sleep 10

puts @browser.link(:text => 'Edit').to_s
@browser.link(:text => 'Edit').click


puts("1")
sleep 2
retries = 3
puts("2")
begin
	puts("3")
	@browser.h5(:text => 'Additional Business Details').when_present.click
	sleep 1 #Animation length
	puts("4")
	@browser.text_field(:name => 'AdditionalBusinessInfo.OpHourDetail.AdditionalInformation').set data['hours']
	@browser.text_field(:name => 'AdditionalBusinessInfo.Description').set data['description']
	@browser.text_field(:name => 'AdditionalBusinessInfo.YearEstablished').set data['founded']
	puts("5")
rescue Selenium::WebDriver::Error::ElementNotVisibleError
	if retries > 0
		retries -= 1
		retry
	else
		puts("Cound not add business hours, description, and year founded.")
	end
end

retries = 3
begin
	@browser.h5(:text => "Other Contact Information").click
	puts("6")
	sleep 2
	if data['mobile_appears']
		puts("7")
		@browser.text_field(:name => 'AdditionalBusinessInfo.MobilePhoneNumber').set data['mobile']
		puts("8")
	end
	@browser.text_field(:name => 'AdditionalBusinessInfo.TollFreeNumber').set data['tollfree']
	puts("9")
	@browser.text_field(:name => 'AdditionalBusinessInfo.FaxNumber').set data['fax']
rescue Selenium::WebDriver::Error::ElementNotVisibleError
	if retries > 0
		retries -= 1
		retry
	else
		puts("Cound not add additional phone numbers")
	end
end
puts("10")
retries = 3
begin
	@browser.h5(:text => "General Information").click
	puts("11")
	sleep 1

	data['payments'].each do |pay|
		puts("12")
		@browser.checkbox(:id => pay).clear
		@browser.checkbox(:id => pay).click
	end
rescue Selenium::WebDriver::Error::ElementNotVisibleError
	if retries > 0
		retries -= 1
		retry
	else
		puts("Cound not add payment methods.")
	end
end

@browser.button(:id => 'submitBusiness').click
puts("13")
sleep 2
Watir::Wait.until { @browser.text.include? "All Businesses" }
puts("14")
if @chained
	self.start("Bing/VerifyMail")
end

true