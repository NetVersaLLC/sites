def sign_in(data)
	@browser.goto("http://ebusinesspages.com/")
	if @browser.link(:text => 'Log Out').exists?
		browser.link(:text => 'Log Out').click
		30.times { break if (begin @browser.link(:text => 'Login').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
	end
	@browser.link(:text => 'Login').when_present.click
	@browser.text_field(:name => 'UserName').set data['username']
	@browser.text_field(:name => 'Password').set data['password']
	@browser.button(:id => 'LoginButton').click
  sleep 3
end