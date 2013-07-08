def add_business ( data )

	@browser.goto('http://mojopages.com/biz/add')
	# click the "Add your business to our directory" link
#	@browser.link(:text, 'Add Business').click
	Watir::Wait::until do @browser.text.include? 'Add your business' end
	
	#fill out giant form
	@browser.text_field( :id => 'name' ).set data[ 'business' ]
	@browser.text_field( :id => 'owner.firstName' ).set data[ 'first_name' ]
	@browser.text_field( :id => 'owner.lastName' ).set data[ 'last_name' ]
	@browser.text_field( :id => 'owner.email' ).set data[ 'email' ]
	@browser.text_field( :id => 'address.streetName' ).set data[ 'streetnumber' ]
	@browser.text_field( :id => 'address.city' ).set data[ 'citystate' ]
	@browser.text_field( :id => 'address.postalCode' ).set data[ 'zip' ]
	@browser.text_field( :id => 'fullPhone' ).set data[ 'phone' ]
	@browser.text_field( :id => 'url' ).set data[ 'url' ]
	@browser.text_field( :id => 'businessDescription' ).set data[ 'tagline' ]
	@browser.text_field( :id => 'businessMetaDescription' ).set data[ 'description' ] + "asdfadfs dasfasdf dasfasdfadfs dasfasdf dasfasdfadfs dasfasdf dasfasdfadfs dasfasdf dasfasdfadfs dasfasdf dasf"
	@browser.text_field( :id => 'owner.password' ).set data[ 'password' ]
	@browser.text_field( :xpath => '/html/body/div/div[3]/div[2]/div/div[2]/div[2]/div/div[3]/form/div[4]/div[12]/input' ).set data[ 'password' ]

	#captcha_text = solve_captcha()
	#@browser.text_field( :id => 'recaptcha_response_field').set captcha_text	
	
	
	# submit the form
	#@browser.button( :value => 'Continue' ).click
	
	enter_captcha( data )
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Mojopage'
	

	#Wait until the Choose Category Screen loads
	sleep(2)
	Watir::Wait::until do @browser.text.include? 'Choose your business category' end
	#Enter the business' category
  puts(data['category'])
	@browser.text_field( :name => 'category' ).set data[ 'category' ]
	@browser.button( :value => 'Find Category' ).click
	
	#Wait until category ajax loads
	#Watir::Wait::until do @browser.radio( :name => 'category' ).exists? or  @browser.text.include? 'No results found. Try a different keyword' end

	#does the category exist?
	if @browser.text.include? 'No results found. Try a different keyword'
		#Category doesn't exist and we need to use a different one to continue.
		#raise StandardError.new( 'That category doesn\'t exist!' )
		#manually enter a new category
		@browser.text_field( :name => 'category' ).set gets
		#TODO possible automate a second try for category
		@browser.button( :value => 'Find Category').click
		sleep 3

	end

	#Finalize category selection
	@browser.radio( :name => 'category' ).set

	#wait for final step to load than confirm the signup process
	Watir::Wait::until do @browser.text.include? 'Almost done! Please verify your new business account information.' end
	@browser.link( :class => 'bizCenterButton greenButton').click

puts("MojoPages business added successfully")

end
add_business( data )
true
