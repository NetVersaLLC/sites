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
	Watir::Wait::until do @browser.text_field( :id => 'email').exists? end
	
	#fill signup form
	@browser.text_field( :id => 'firstName' ).set business[ 'first_name' ]
	@browser.text_field( :id => 'lastName' ).set business[ 'last_name' ]	
	@browser.text_field( :id => 'email' ).set business[ 'email' ]
	@browser.text_field( :id => 'password' ).set business[ 'password' ]
	@browser.text_field( :id => 'confirmPassword' ).set business[ 'password' ]
	@browser.text_field( :id => 'postalCode' ).set business[ 'zip' ]

	#gender selection
	if business[ 'gender' ] == 'male'
		@browser.radio( :id => 'Male').set
	else
		@browser.radio( :id => 'Female').set
	end
	
	#click submit
	@browser.button( :id => 'proceed').click

	#loads user page
	Watir::Wait::until do @browser.text.include? 'Welcome Back' end
	
	#now that we are signed up we need to go back and actually claim the business, since it skips that step when we go to sign up.
	@browser.link( :text => 'Sign up today').click
	
	#wait until page loads
	Watir::Wait::until do @browser.text.include? 'Enter your business phone # to find your business' end
	
	#enter phone number
	@browser.text_field( :id => 'areaCode' ).set business[ 'phone_area' ]
	@browser.text_field( :name => 'exchange' ).set business['phone_prefix' ]
	@browser.text_field( :name => 'phoneNumber' ).set business[ 'phone_suffix' ]
	@browser.button( :value => 'Find My Business' ).click
	
	#wait until 'This your business? loads
	Watir::Wait::until do @browser.text.include? 'Is this your business?' end
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Mojopage'
	#say yes
	@browser.link( :class => 'button positive').click

	Watir::Wait::until do @browser.checkbox( :name => 'confirmBox').exists? end
	sleep(5)
	#check box to confirm terms and conditions


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
	Watir::Wait::until do @browser.radio( :name => 'category' ).exists? or  @browser.text.include? 'No results found. Try a different keyword' end


	#does the category exist?
	if @browser.text.include? 'No results found. Try a different keyword'
		#Category doesn't exist and we need to use a different one to continue.
		#raise StandardError.new( 'That category doesn\'t exist!' )
		#manually enter a new category

		@browser.text_field( :name => 'category' ).set gets
		#TODO Possibly automate a second try for category. 
		
		@browser.button( :value => 'Find Category').click
		sleep 3

	end

	#Finalize category selection
	@browser.radio( :name => 'category' ).set
	end
	
	#final confirmation step
	Watir::Wait::until do @browser.text.include? 'Almost done! Please verify your new business account information.' end
	@browser.link( :class => 'bizCenterButton greenButton').click


end

claim_business( data )
