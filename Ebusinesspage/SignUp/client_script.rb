@browser.goto('http://ebusinesspages.com/')

if @browser.link(:text => 'Log Out').exists
	@browser.link(:text => 'Log Out').click
	30.times { break if (begin @browser.link(:text => 'Register').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
end

@browser.link(:text => 'Register').click

@browser.text_field(:name => 'UserName').set data['username']
@browser.text_field(:name => 'Password').set data['password']
@browser.text_field(:name => 'FirstName').set data['fname']
@browser.text_field(:name => 'LastName').set data['lname']
@browser.text_field(:name => 'Email').set data['email']

@browser.button(:name => 'RegisterButton').click

self.save_account("Ebusinesspage", {:username => data['username'], :password => data['password']})

sleep(10) #Registration takes a long time to appear
#Watir::Wait.until { @browser.link(:text => 'Log Out').exists? }
30.times { break if (begin @browser.link(:text => 'Log Out').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
if @chained
	self.start("Ebusinesspage/AddListing")
end
true