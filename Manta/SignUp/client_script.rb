#method for adding the company to the Manta listing

def add_company( data )

	#verify we are on the correct page. 
	Watir::Wait::until do @browser.text.include? 'Tell Us About Your Company' end
	
	#select the country
	#There is obfuscated javascript that causes dynamic events to occur live while you enter data
	#To fire these events I needed to focus, enter the information, than send the tab key.
	@browser.select_list(:id, 'co_Country').focus
	@browser.select_list( :id => 'co_Country').select data[ 'country' ]
	@browser.send_keys :tab

	if @browser.select_list( :id => 'co_State' ).exists?
		@browser.select_list(:id, 'co_State').focus
		@browser.select_list( :id => 'co_State' ).select data[ 'state' ]
		@browser.send_keys :tab		
	end

	#enter the rest of the company information
	@browser.text_field( :id, 'co_City').set data[ 'city' ]
	@browser.text_field( :id, 'co_Name').set data[ 'business' ]
	@browser.text_field( :id, 'co_Address').set data[ 'streetnumber' ]
	@browser.text_field( :id, 'co_Phone').set data[ 'phone' ]
	@browser.text_field( :id, 'co_Zip').set data[ 'zip' ]	

	#Select the What is your relationship to this company radio group
	@browser.radio( :value, 'owner').set
	@browser.button( :id, 'SUBMIT').click
	
	#wait until the next page loads
	Watir::Wait::until do @browser.text.include? "What's your relationship to" end

	#fill out member form
	@browser.text_field( :id, 'member-firstname-preroll').focus
	@browser.text_field( :id, 'member-firstname').set data[ 'first_name' ]
	@browser.text_field( :id, 'member-lastname-preroll').focus
	@browser.text_field( :id, 'member-lastname').set data[ 'last_name' ]
	@browser.text_field( :id, 'member-email').focus
	@browser.text_field( :id, 'member-email').set data[ 'email' ]
	@browser.text_field( :id, 'member-email_confirm').focus
	@browser.text_field( :id, 'member-email_confirm').set data[ 'email' ]
	@browser.text_field( :id, 'member-password').focus
	@browser.text_field( :id, 'member-password').set data[ 'password' ]
	@browser.text_field( :id, 'member-confirm_password').focus
	@browser.text_field( :id, 'member-confirm_password').set data[ 'password' ]	

	#uncheck the newsletters
	@browser.checkbox( :id, 'manta-smb' ).clear
	@browser.checkbox( :id, 'over-quota' ).clear
	
	@browser.link(:class, 'btn-join btn-continue').click
	
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Manta'
	sleep(5)
	
	@browser.goto('http://www.manta.com/')
	
	thelink = @browser.link( :text , data[ 'business' ]).href
	@browser.goto(thelink)
	
	
sleep(5)
@browser.button(:text, 'Done').click
sleep(2)


true


end 



def main( data )

#load the browser and navigate to the business search page

	@browser.goto('http://www.manta.com/profile/my-companies/select?add_driver=home-getstarted')

add_company( data )

end

main( data )

if @chained
      self.start("Manta/Verify")
    end

true
