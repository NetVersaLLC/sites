@browser.goto(data['url'])

begin
	
	@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']
	@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPasswordConfirm').set data['password']
	@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdSave').click
	sleep 2
	Watir::Wait.until{ @browser.text.include? "Your Dashboard" }
rescue
	if not @browser.text.include? "Your Dashboard"
		throw "Something went wrong Verifying ExpressBusinessDirectory"
	end
end

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'model' => 'Expressbusinessdirectory'

if @chained 
	self.start('Expressbusinessdirectory/FinishListing')

true