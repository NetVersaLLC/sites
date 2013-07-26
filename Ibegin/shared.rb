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
       		throw("Job failed during login. Verify the credintials are valid")
   		end
	end
end


def loop_cats(data)
	catarray = data['category1'].split(" ")
	wordcount = catarray.length
	count = 0
	
	while wordcount > count
		@browser.window( :title, "Categories Selector | iBegin").when_present.use do
			query = catarray[count]
			@browser.text_field( :id, 'id_q').set query
			@browser.button( :value, 'Go').click
			sleep 5
			if @browser.link(:text => /#{query}/i).exists?
				@browser.link(:text => /#{query}/i).click
				break
			end
			count+=1
		end
	end

end