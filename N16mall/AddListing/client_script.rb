@browser = Watir::Browser.new
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

if data['company_website'].nil? || data['company_website'] == ""
	self.success("Client does not have a website")
else
	@browser.goto 'http://www.916mall.com/formpage.htm'

	@browser.text_field(:id => 'name').set data['business_name']
	@browser.text_field(:id => 'field-e2b383d31244ddd').set data['city']
	@browser.text_field(:id => 'field-a788b27a86496d2').set data['company_website']
	@browser.text_field(:id => 'email').set data['email']
	@browser.text_field(:id => 'field-7ab5ee2252d01de').set data['local_phone']
	@browser.text_field(:id => 'field-1b35616ab358005').set data['category']
	@browser.text_field(:id => 'field-559853f63787f6d').set data['city']
	@browser.checkbox(:id => 'field-0a2c02d5ab8dff1_5').set
	@browser.button(:value => ' Submit Form ').click
	@browser.link(:id => 'continue_link').when_present.click

	Watir::Wait.until { @browser.text.include? "Your message has been sent" }

	true
end