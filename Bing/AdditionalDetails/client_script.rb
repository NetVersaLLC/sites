@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}


def sign_in_business( business )

retries = 3
begin
    @browser.goto( 'https://www.bingplaces.com/' )

    @browser.button(:id => 'loginButton').click

    sleep 2
    @browser.link(:text => 'Login').when_present.click

    email_parts = {}
    email_parts = business[ 'hotmail' ].split( '.' )
    sleep 2
    Watir::Wait.until { @browser.input( :name, 'login' ).exists? }

    @browser.input( :name, 'login' ).send_keys email_parts[ 0 ]
    @browser.input( :name, 'login' ).send_keys :decimal
    @browser.input( :name, 'login' ).send_keys email_parts[ 1 ]
    # TODO: check that email entered correctly since other characters may play a trick
    @browser.text_field( :name, 'passwd' ).set business[ 'password' ]
    # @browser.checkbox( :name, 'KMSI' ).set
    @browser.button( :name, 'SI' ).click

    sleep 2
    Watir::Wait.until {@browser.button(:id => 'loginButton').exists?}

    if @browser.button(:id => 'loginButton').text =~ /Sign in/i
      throw "Sign-in failed"
    end


  rescue Exception => e
    if retries > 0
      puts e.inspect
      retries -= 1
      retry
    else
      throw "Sign in was not able to complete. "
    end
  end



end

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
		puts("Could not add additional phone numbers")
	end
end

retries = 3
begin
	@browser.h5(:text => "General Information").click
	sleep 1

	data['payments'].each do |pay|
        puts "Payment: " + pay
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