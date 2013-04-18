def goto_signup_page
	puts 'Loading Signup Page for Linkedin'
	@browser.goto('https://www.linkedin.com/reg/join?trk=hb_join')
end

def process_linkedin_signup(profile)
	puts 'Sign up for new Linkedin account'
	@browser.text_field(:name => 'firstName').set profile['first_name']
	@browser.text_field(:name => 'lastName').set profile['last_name']
	@browser.text_field(:name => 'email').set profile['email']
	@browser.text_field(:name => 'password').set profile['password']

	@browser.button(:id => 'btn-submit').click



sleep(10) #Waits are being dumb here, sleep seems to be the only way.
	
	
	if @browser.text.include? "We need to verify you're not a robot!"
	
		enter_captcha_signup( profile )

	end

	Watir::Wait.until { @browser.select_list(:name, "countryCode").exists? } 


	no_skip = false
	#begin
	#	Watir::Wait.until {@browser.link(:class, "skip").exists?}
	#	@browser.link(:class => 'skip').click
	#rescue
	#	no_skip = true
	#end

sleep(2)
	
	@browser.select_list(:name => 'countryCode').select profile['country']
	@browser.text_field(:name => 'postalCode').set profile['postalcode']

	@browser.radio(:name => 'status-chooser', :value => profile['status']).set

	if profile['status'] == 'looking'
		@browser.wait_until {@browser.text_field(:id, "workCompanyTitle-lookingProfileForm").visible?}
		@browser.text_field(:id => 'workCompanyTitle-lookingProfileForm').set profile['jobtitle']

		if profile['self_employed'] === true

			@browser.checkbox(:id => 'selfEmployed-employeeCompany-lookingProfileForm').set

		else
			@browser.text_field(:id => 'companyName-companyInfo-employeeCompany-lookingProfileForm').set profile['company']

		end

		@browser.wait_until {@browser.select_list(:id, "industryChooser-employeeCompany-lookingProfileForm").visible?}

		@browser.select_list(:id => 'industryChooser-employeeCompany-lookingProfileForm').select profile['industry']
		@browser.select_list(:name => 'startYear').select profile['startYear']

		@browser.select_list(:name => 'endYear').select profile['endYear']

		@browser.button(:id => 'looking-btn-submit').click
	elsif profile['status'] == 'student'
		@browser.text_field(:id => 'schoolText-school-education-studentProfileForm').set profile['university']

		@browser.select_list(:id => 'startYear-startEndYear-education-studentProfileForm').select profile['startYear']
		@browser.select_list(:id => 'endYear-startEndYear-education-studentProfileForm').select profile['endYear']

		@browser.button(:id => 'student-btn-submit').click
	else
		@browser.text_field(:name => 'workCompanyTitle').set profile['jobtitle']

		@browser.text_field(:name => 'companyName').set profile['company']

		if profile['self_employed'] === true and @browser.checkbox(:name => 'selfEmployed').exists?
			@browser.checkbox(:name => 'selfEmployed').set true
		end

		@browser.wait_until {@browser.select_list(:name, "industryChooser").visible?}
		@browser.select_list(:name => 'industryChooser').select profile['industry']

		@browser.button(:id => 'employed-btn-submit').click
	end

	if no_skip
		@browser.wait_until {@browser.p(:class => 'skip').exists?}
		@browser.p(:class => 'skip').link(:index => 0).click
		
		begin
			@browser.wait_until {@browser.div(:id => 'abook-benefits-prompt').exists?}
			@browser.div(:id => 'abook-benefits-prompt').link(:class => 'btn-secondary').click
		rescue
		end
	end
sleep(1)


	@browser.link( :id => 'skipButton').when_present.click
	sleep(3)	

	@browser.div(:id => 'dialog-wrapper').link( :text => /Skip/).click

	Watir::Wait.until {@browser.div(:class, "confirm-prompt").exists?}

	puts 'Signup is Completed'
end

def goto_signin_page
	puts 'Loading Signin Page for Linkedin'
	@browser.goto('https://www.linkedin.com/uas/login')
end

def process_linkedin_signin(profile)
	puts 'Signin to your Linkedin account'
	@browser.text_field(:name => 'session_key').set profile['email']
	@browser.text_field(:name => 'session_password').set profile['password']

	@browser.button(:name => 'signin').click
	sleep(3)
	puts 'Signin is Completed'
end

def goto_recover_page
	puts 'Loading Password Recover Page for Linkedin'
	@browser.goto('https://www.linkedin.com/uas/request-password-reset?session_redirect=')
end

def process_linkedin_recover(email)
	puts 'Recover your Linkedin account'
	@browser.text_field(:name => 'email').set email

	@browser.button(:id => 'request').click

	@browser.wait_until {@browser.div(:class, "reset").exists?}

	puts 'Recover Account is Completed'
end

def close_browser
	if !@browser.nil?
		puts 'Browser Closed'
		@browser.close
	end
end

def solve_captcha_signup
  image = "#{ENV['USERPROFILE']}\\citation\\digabusiness_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="recaptcha_image"]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"

  obj.save image
  CAPTCHA.solve image, :manual
end

def enter_captcha_signup( data )
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha_signup	
		@browser.text_field( :id => 'recaptcha_response_field').set captcha_code
		@browser.button( :value => 'Continue').click
		sleep(2)
		if not @browser.text.include? "The text you entered does not match the characters in the security image."
			capSolved = true
		end	  
	count+=1
	end
	if capSolved == true
		true
	else
		throw("Captcha was not solved")
	end
end