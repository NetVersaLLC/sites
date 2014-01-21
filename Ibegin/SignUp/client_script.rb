@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

retries = 5
begin
@browser.goto('http://www.ibegin.com/account/register/')
@browser.text_field( :name, 'name').set data[ 'username' ]
@browser.text_field( :name, 'liame').set data[ 'email' ]
@browser.text_field( :name, 'pw' ).set data[ 'password' ]

@browser.button( :value, /Register/i).click
sleep 2
Watir::Wait.until { @browser.text.include? "Business owners - over a million people view these listings every month" or @browser.lis(:style => 'color:red;').size > 0 }
	
	if @browser.lis(:style => 'color:red;').size > 0
		@browser.lis(:style => 'color:red;').each do |error|
			puts(error.text)
		end
		throw ("Handling errors")
	end

	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Ibegin'

	if @chained
		self.start("Ibegin/CreateListing")
	end

	true
rescue
	if retries > 0
       puts "There was an error with the payload. Retrying in 5 seconds."
       retries -= 1
       sleep 5
       retry
   else
       puts "After 5 retries the payload could not run. Data that was attempted:"
       puts data['email']
       puts data['password']
       throw("Job failed.")
   end
end

