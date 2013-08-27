sign_in( data )
@browser.goto( 'mail.live.com/mail/options.aspx' )

30.times { break if (begin @browser.link(:id => "iShowSkip").exists? or @browser.frame( :id, 'appFrame').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

if @browser.link(:id => "iShowSkip").exists?
	@browser.link(:id => "iShowSkip").click

	30.times { break if (begin @browser.text.include? "Account summary" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
	
	@browser.goto( 'mail.live.com/mail/options.aspx' )	

	30.times { break if (begin @browser.frame( :id, 'appFrame').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
	
end

@opt_frame = @browser.frame( :id, 'appFrame')
30.times { break if (begin @opt_frame.link( :text, /Rules for sorting new messages/i).present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
@opt_frame.link( :text, /Rules for sorting new messages/i).when_present.click
30.times { break if (begin @opt_frame.button( :id, 'NewFilter').present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
@opt_frame.button( :id, 'NewFilter').when_present.click

@opt_frame.select_list( :id, 'VerbDropDown').select "contains"
@opt_frame.text_field( :id, 'MatchString').set "@"
@opt_frame.button( :value, /Save/).click

if @chained
		self.start("Bing/CreateListing")
end

true