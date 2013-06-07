begin
	@browser.goto data['url']

rescue Selenium::WebDriver::Error::UnhandledAlertError
	true	

end

