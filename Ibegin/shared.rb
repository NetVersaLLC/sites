def sign_in( data )

retries = 5

	begin
		@browser.goto( 'http://www.ibegin.com/account/login/' )
		@browser.text_field( :name, 'name' ).set data['email']
		@browser.text_field( :name, 'pw' ).set data['password']

		@browser.button( :value, /Login/i).click

		sleep 2
		Watir::Wait.until { @browser.link(:text => 'Logout').exists? }
		return true
	rescue
		if retries > 0
       		puts "There was an error with the SignUp. Retrying in 5 seconds."
       		retries -= 1
       		sleep 5
       		retry
   		else
       		puts "After 5 retries the payload could not sign in. Data available:"
       		puts data
       		puts "Data required:"
       		puts "email,password"
       		throw("Job failed.")
   		end
	end
end
