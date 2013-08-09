def add_business ( data )

	@browser.goto('http://mojopages.com/biz/add')
	# click the "Add your business to our directory" link
#	@browser.link(:text, 'Add Business').click
	sleep(2)
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
	if data['tagline'].nil? then
		@browser.text_field( :id => 'businessDescription' ).set " "*110
	else
		@browser.text_field( :id => 'businessDescription' ).set data[ 'tagline' ]
	end
	if @browser.span(:id, 'shortDescriptionCharacters').visible?
		until not @browser.span(:id, 'shortDescriptionCharacters').visible?
			@browser.text_field( :id => 'businessDescription' ).send_keys :space
		end
	end
	@browser.text_field( :id => 'businessMetaDescription' ).set data[ 'description' ]
	if @browser.span(:id, 'descriptionCharacters').visible?
		until not @browser.span(:id, 'descriptionCharacters').visible?
			@browser.text_field(:id, 'businessMetaDescription').send_keys :space
		end
	end
	@browser.text_field( :id => 'owner.password' ).set data[ 'password' ]
	@browser.text_field( :xpath => '/html/body/div/div[3]/div[2]/div/div[2]/div[2]/div/div[3]/form/div[4]/div[12]/input' ).set data[ 'password' ]

	#captcha_text = solve_captcha()
	#@browser.text_field( :id => 'recaptcha_response_field').set captcha_text	
	
	
	# submit the form
	#@browser.button( :value => 'Continue' ).click
	
	enter_captcha( data )
	sleep(2)
	if @browser.text.include? "Another user with the same email address already exists."
		raise("Another user with the same email address already exists.")
	end
	puts(data['email'])
	puts(data['password'])
	self.save_account("Mojopage", {:email => data['email'], :password => data['password']})
	

	#Wait until the Choose Category Screen loads
	sleep(4)
	Watir::Wait::until do @browser.text.include? 'Choose your business category' end
	#Enter the business' category
  puts(data['category'])
	@browser.text_field( :name => 'category' ).set data[ 'category' ]
	@browser.button( :value => 'Find Category' ).click
	sleep(5)
	
	#Wait until category ajax loads
	#Watir::Wait::until do @browser.radio( :name => 'category' ).exists? or  @browser.text.include? 'No results found. Try a different keyword' end

	if @browser.radio(:value, data['category']).exists? then
		@browser.radio(:value => data['category']).set
	else
		@browser.text_field( :name => 'category' ).set data['category'].split(" ").first
		@browser.button( :value => 'Find Category' ).click
		sleep(2)
		if @browser.radio(:value, data['category']).exists? then
			@browser.radio(:value => data['category']).set
		else
			@browser.text_field( :name => 'category' ).set data['category'].split(" ").last
			@browser.button( :value => 'Find Category' ).click
			sleep(2)
			if @browser.radio(:value, data['category']).exists? then
				@browser.radio(:value => data['category']).set
			else
				@browser.text_field( :name => 'category' ).set data['category'].split(" ").first
				@browser.button( :value => 'Find Category' ).click
				sleep(2)
				if @browser.radio(:value, data['category'].split(" ").first).exists? then
					@browser.radio(:value => data['category'].split(" ").first).set
				else
					@browser.text_field( :name => 'category' ).set data['category'].split(" ").last
					@browser.button( :value => 'Find Category' ).click
					sleep(2)
					if @browser.radio(:value, data['category'].split(" ").last).exists? then
						@browser.radio(:value => data['category'].split(" ").last).set
					else
						throw("Category could not be found")
						#puts("Attempting to find category one letter at a time...")
						#cycle = 1
						#piece_by_piece = data['category'].chars.to_a
						#kaz = piece_by_piece[0]
						#until cycle > piece_by_piece.length
						#	@browser.text_field( :name => 'category' ).set kaz
						#	@browser.button( :value => 'Find Category' ).click
						#	sleep(4)
						#	if @browser.radio(:value, data['category']).exists? then
						#		browser.radio(:value => data['category']).set
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


	#wait for final step to load than confirm the signup process
	sleep(2)
	Watir::Wait::until do @browser.text.include? 'Almost done! Please verify your new business account information.' end
	@browser.link( :class => 'bizCenterButton greenButton').click

puts("MojoPages business added successfully")

end
add_business( data )
true
