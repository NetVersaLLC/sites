sign_in_business( data )
sleep 2
Watir::Wait.until { @browser.text.include? "All Businesses" }

@browser.link(:text => 'Edit').click

sleep 2
retries = 3
begin
	@browser.h5(:text => 'Additional Business Details').when_present.click
	sleep 1 #Animation length
	@browser.text_field(:name => 'AdditionalBusinessInfo.OpHourDetail.AdditionalInformation').set data['hours']
	@browser.text_field(:name => 'AdditionalBusinessInfo.Description').set data['description']
	@browser.text_field(:name => 'AdditionalBusinessInfo.YearEstablished').set data['founded']
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
	sleep 2
	if data['mobile_appears']
		@browser.text_field(:name => 'AdditionalBusinessInfo.MobilePhoneNumber').set data['mobile']
	end
	@browser.text_field(:name => 'AdditionalBusinessInfo.TollFreeNumber').set data['tollfree']
	@browser.text_field(:name => 'AdditionalBusinessInfo.FaxNumber').set data['fax']
rescue Selenium::WebDriver::Error::ElementNotVisibleError
	if retries > 0
		retries -= 1
		retry
	else
		puts("Cound not add additional phone numbers")
	end
end

retries = 3
begin
	@browser.h5(:text => "General Information").click
	sleep 1

	data['payments'].each do |pay|
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

sleep 2
Watir::Wait.until { @browser.text.include? "All Businesses" }

if @chained
	self.start("Bing/VerifyMail")
end

true