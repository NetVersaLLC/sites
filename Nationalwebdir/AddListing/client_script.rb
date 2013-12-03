@browser = Watir::Browser.new
at_exit {
	unless @browser.nil?
		@browser.close
	end
}
if data['website'].nil? || data['website'] == ""
	self.success("Client does not have a website")
else
	@browser.goto 'http://nationalwebdirectory.net/add.php'

	@browser.text_field(:name => 'company').set data['business_name']
	@browser.text_field(:name => 'website').set data['company_website']
	@browser.text_field(:name => 'email').set data['email']
	@browser.text_field(:name => 'city').set data['city']
	@browser.select_list(:name => 'state').select data['state']
	@browser.select_list(:name => 'category').select data['category']
	@browser.textarea(:name => 'description').set data['business_description']
	@browser.button(:value => ' add your listing ').click

	sleep 5

	if @browser.text.include? "Thank you for registering with The National Web Directory!"
		true
	else
		raise "Payload did not submit"
	end
end