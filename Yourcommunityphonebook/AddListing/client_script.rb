@browser = Watir::Browser.new
at_exit {
	unless @browser.nil?
		@browser.close
	end
}
@browser.goto 'http://www.yourcommunityphonebook.com/add.aspx'

@browser.text_field(:id => 'Name').set data['business_name']
@browser.text_field(:id => 'Address').set data['address']
@browser.text_field(:id => 'drpCity').set data['city']
@browser.text_field(:id => 'State').set data['state']
@browser.text_field(:id => 'Zip').set data['zip']
@browser.text_field(:id => 'txtPhone1').set data['local_phone']
@browser.text_field(:id => 'Fax').set data['fax_number']
@browser.text_field(:id => 'txtweb').set data['company_website']
@browser.text_field(:id => 'email').set data['category']#data['email']
@browser.text_field(:id => 'LName').set data['contact_last_name']
@browser.text_field(:id => 'FName').set data['contact_first_name']
@browser.select_list(:id => 'drpCategory').select data['category']
@browser.button(:id => 'btnSubmit').click

Watir::Wait.until { @browser.span( :id => 'lblAnswer').exists? }

true