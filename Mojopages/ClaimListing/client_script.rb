def claim_business( business )


#stuffandthings = @browser.execute_script "return document.title"
	
#puts(stuffandthings)
#puts('I just did something above this line')

	area = business[ 'phone_area' ]
	prefix = business[ 'phone_prefix' ]
	suffix = business[ 'phone_suffix' ]
url = "http://mojopages.com/biz/find?areaCode=#{area}&exchange=#{prefix}&phoneNumber=#{suffix}"
	@browser.goto(url)
	#confirm your business
#	@browser.link( :class => 'button positive').click
	
	#Confirm box has popped up

#	sleep(4)


	#click sign up
#	@browser.link( :text => 'Sign Up').focus
	@browser.link( :text => 'Sign Up').click
#sleep(4)
	#wait till form loads
	sleep(2)
	Watir::Wait::until do @browser.text_field( :id => 'email').exists? end
	
	#fill signup form
	@browser.text_field( :id => 'firstName' ).set business[ 'first_name' ]
	@browser.text_field( :id => 'lastName' ).set business[ 'last_name' ]	
	@browser.text_field( :id => 'email' ).set business[ 'email' ]
	@browser.text_field( :id => 'password' ).set business[ 'password' ]
	@browser.text_field( :id => 'confirmPassword' ).set business[ 'password' ]
	@browser.text_field( :id => 'postalCode' ).set business[ 'zip' ]

	#gender selection
	if business[ 'gender' ] == 'male' or business[ 'gender' ] == "Unknown"
		@browser.radio( :id => 'Male').set
	else
		@browser.radio( :id => 'Female').set
	end
	
	#click submit
	@browser.button( :id => 'proceed').click
	sleep(2)
	if @browser.text.include? "Another user with the same email address already exists."
		@browser.goto("http://mojopages.com/login")
		@browser.text_field(:name => 'username').set business['f_email']
		@browser.text_field(:name => 'password').set business['f_password']
		@browser.button(:value => 'Login').click
		sleep(2)
		Watir::Wait::until do @browser.text.include? 'Welcome' end
		@browser.goto("http://www.mojopages.com/biz/signup")
	else


	#loads user page
	sleep(2)
	Watir::Wait::until do @browser.text.include? 'Welcome' end
	self.save_account("Mojopages", {:email => business['email'], :password => business['password']})
	#now that we are signed up we need to go back and actually claim the business, since it skips that step when we go to sign up.
	@browser.goto("http://www.mojopages.com/biz/signup")
	end
	
	#wait until page loads
	sleep(2)
	Watir::Wait::until do @browser.text.include? 'Enter your business phone # to find your business' end
	
	#enter phone number
	@browser.text_field( :id => 'areaCode' ).set business[ 'phone_area' ]
	@browser.text_field( :name => 'exchange' ).set business['phone_prefix' ]
	@browser.text_field( :name => 'phoneNumber' ).set business[ 'phone_suffix' ]
	@browser.button( :value => 'Find My Business' ).click
	puts(business[ 'phone_area' ] + business['phone_prefix' ] + business[ 'phone_suffix' ])
	
	#wait until 'This your business? loads
	sleep(2)
	Watir::Wait::until do @browser.text.include? 'Is this your business?' end
	#say yes
	@browser.link( :class => 'button positive').click


	sleep(2)
	Watir::Wait::until do @browser.checkbox( :name => 'confirmBox').exists? end
	sleep(5)
	#check box to confirm terms and conditions
	@browser.checkbox( :name => 'confirmBox').click
	@browser.button(:value, 'Continue').click
	sleep(5)

theform = @browser.form(:action, '/business/claim').id


@browser.execute_script "document.getElementById('#{theform}').submit();"
#@browser.execute_script "return confirm( this );" 

#	@browser.checkbox( :name => 'confirmBox').set
#	@browser.button( :value => 'Continue').click

	if @browser.text.include? 'This business has already been claimed.'
		raise StandardError.new( 'This business has already been claimed. Please contact support@mojopages.com if you believe this is an error' )
	end


	
	#wait until the page loads to select a category, or confirm category
	@category_already_set = @browser.text.include? 'Confirm your category'
	@set_category_needed = @browser.text.include? 'Choose your business category'
	sleep(2)
	Watir::Wait::until do @category_already_set or @set_category_needed end
	

	#check if category has already been set or if it needs to be selected
	if @category_already_set
		#category already set
		@browser.link( :class => 'button positive').click
	elsif @set_category_needed
		#category needs to be set
		@browser.text_field( :name => 'category' ).set business[ 'category' ]
		@browser.button( :value => 'Find Category' ).click
	
	#Wait until category ajax loads
	sleep(2)
	Watir::Wait::until do @browser.radio( :name => 'category' ).exists? or  @browser.text.include? 'No results found. Try a different keyword' end

	if @browser.radio(:value, business['category']).exists? then
		@browser.radio(:value => business['category']).set
	else
		@browser.text_field( :name => 'category' ).set business['category'].split(" ").first
		@browser.button( :value => 'Find Category' ).click
		sleep(2)
		if @browser.radio(:value, business['category']).exists? then
			@browser.radio(:value => business['category']).set
		else
			@browser.text_field( :name => 'category' ).set business['category'].split(" ").last
			@browser.button( :value => 'Find Category' ).click
			sleep(2)
			if @browser.radio(:value, business['category']).exists? then
				@browser.radio(:value => business['category']).set
			else
				@browser.text_field( :name => 'category' ).set business['category'].split(" ").first
				@browser.button( :value => 'Find Category' ).click
				sleep(2)
				if @browser.radio(:value, business['category'].split(" ").first).exists? then
					@browser.radio(:value => business['category'].split(" ").first).set
				else
					@browser.text_field( :name => 'category' ).set business['category'].split(" ").last
					@browser.button( :value => 'Find Category' ).click
					sleep(2)
					if @browser.radio(:value, business['category'].split(" ").last).exists? then
						@browser.radio(:value => business['category'].split(" ").last).set
					else
						throw("Category could not be found")
						#puts("Attempting to find category one letter at a time...")
						#cycle = 1
						#piece_by_piece = business['category'].chars.to_a
						#kaz = piece_by_piece[0]
						#until cycle > piece_by_piece.length
						#	@browser.text_field( :name => 'category' ).set kaz
						#	@browser.button( :value => 'Find Category' ).click
						#	sleep(4)
						#	if @browser.radio(:value, business['category']).exists? then
						#		browser.radio(:value => business['category']).set
						#		break
						#	else
						#		kaz << piece_by_piece[cycle]
						#		if cycle > piece_by_piece.length
						#			throw("Category could not be found")
						#		end
						#		cycle += 1
						#	end
						#end
					end
				end
			end
		end
	end
end
	
	#final confirmation step
	sleep(2)
	Watir::Wait::until do @browser.text.include? 'Almost done! Please verify your new business account information.' end
	@browser.link( :class => 'bizCenterButton greenButton').click


end

claim_business( data )
