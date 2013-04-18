def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\localdatabase_captcha.png"
  obj = @browser.div( :id, 'recaptcha_image' ).image( :alt, "reCAPTCHA challenge image")
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha( data )

	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha
		@browser.text_field( :id, 'recaptcha_response_field').set captcha_code
		@browser.text_field(:name, "password").set data['password']
	        @browser.text_field(:name, "passwordconfirm").set data['password']
		@browser.button(:name => 'sub').click

		if not @browser.text.include? "Invalid captcha answer"
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

def goto_signup_page
	puts 'Loading Signup Page for Localdatabase.com'
  	@browser.goto("http://www.localdatabase.com/users/?register")
	#browser_open Localdatabase.signup_url
end

def process_localdatabase_signup(data)
	puts 'Sign up for new Localdatabase.com account'

  @browser.text_field(:name, "username").set data['username']
  @browser.text_field(:name, "password").set data['password']
  @browser.text_field(:name, "passwordconfirm").set data['password']
  @browser.text_field(:name, "email").set data['email']
  @browser.text_field(:name, "emailconfirm").set data['email']
  @browser.select_list(:name, "type").option(:value => data['type']).select



  #@browser.text_field(:id, "recaptcha_response_field").set process_recaptcha_field(@browser)

  enter_captcha( data )
	#log_credentials_to_file('localdatabase', profile['username'], profile['email'], profile['password'])
end

def goto_signin_page
	puts 'Loading Signin Page for Localdatabase.com'
  	@browser.goto('http://www.localdatabase.com/users/?login')
	#browser_open Localdatabase.signin_url
end

def process_localdatabase_signin(profile, fblogin = false)
	puts 'Signin to your Localdatabase.com account'

    @browser.div(:class => 'blindbox').text_field(:name, "vb_login_username").set profile['username']
    @browser.div(:class => 'blindbox').text_field(:name, "vb_login_password").set profile['password']

        @browser.div(:class => 'blindbox').button(:text => 'Log In').click
  
  
    Watir::Wait.until {@browser.text.include? 'Logout'}
  
	puts 'Signin is Completed'
end

def goto_add_business_page
  	@browser.goto('http://www.localdatabase.com/users/?do=business&what=addlisting')
	#browser_open Localdatabase.add_business_url
end

def localdatabase_add_businesses businesses
  i = 1
  businesses.each do |business|
    puts "Adding New Business ##{i}"
    localdatabase_add_business business
    i += 1
  end
end

def localdatabase_add_business business
  sleep 2 and goto_add_business_page

  sleep 3

  @browser.text_field(:name => 'addname').set business['name']
  @browser.text_field(:name => 'addaddress').set business['address']

  @browser.select_list(:id => 'stateselect').option(:text => business['state']).select
  @browser.wait_until {@browser.select_list(:id => 'cityselect').options.length == 0}
  sleep 5 and @browser.select_list(:id => 'cityselect').option(:text => business['city']).select

  @browser.text_field(:name => 'addzipcode').set business['zipcode']
  @browser.text_field(:name => 'addaddress').set business['address']
  @browser.text_field(:name => 'addtelephone').set business['phone']
  @browser.text_field(:name => 'addfax').set business['fax']
  @browser.text_field(:name => 'addweb').set business['website']
  @browser.text_field(:name => 'adddescription').set business['description']
  
  if business['category'] == "root"
    @browser.select_list(:id => 'categoryselect').option(:text => business['subcategories']).select
  else 
    @browser.select_list(:id => 'categoryselect').option(:text => business['category']).select
    sleep(1)
    Watir::Wait.until {@browser.table(:id => 'subcatlist').visible?}

    cats = business['subcategories'].split(',')
    cats.each do |c|
      @browser.table(:id => 'subcatlist').td(:text => c).parent.td(:index => 0).checkbox(:index => 0).set
    end
  end

  @browser.radio(:name => 'addsubscription', :value => business['mtype']).set


  @browser.button(:text => 'Save').click
  puts("Complete")
  Watir::Wait.until {@browser.text.include? 'Your business has been submitted and is under review by one of our staff. We will contact you shortly in regards to the status.'}
true
end

