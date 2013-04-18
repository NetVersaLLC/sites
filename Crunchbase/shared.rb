def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\crunchbase_captcha.png"
  obj = @browser.image( :xpath, '/html/body/div[6]/div[2]/div/form/table/tbody/tr[11]/td/div/div/table/tbody/tr[2]/td[2]/div/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha

	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha
		@browser.text_field( :id, 'recaptcha_response_field').set captcha_code
		@browser.button(:name => 'commit').click
		sleep(2)	
		if not @browser.text.include? "Error with reCAPTCHA!"
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
	puts 'Loading Signup Page for Crunchbase'
	@browser.goto('http://www.crunchbase.com/account/signup')
end

def goto_signin_page
	puts 'Loading Signin Page for Crunchbase'
	@browser.goto('http://www.crunchbase.com/login')
end


def goto_recover_page
	puts 'Loading Password Recover Page for Crunchbase'
	@browser.goto('http://www.crunchbase.com/recovery/new')
end

def process_crunchbase_recover(email)
	puts 'Recover your Crunchbase account'

	@browser.text_field(:id => 'email').set email

	begin
    @browser.button(:name => 'commit').click
  rescue
  end

	@browser.wait_until {@browser.div(:id => 'success_header').exists?}

	puts 'Recover Account is Completed'
end

def close_browser
	if !@browser.nil?
		puts 'Browser Closed'
		@browser.close
	end
end

def process_crunchbase_signin(profile)
	puts 'Signin to your Crunchbase account'

  @browser.text_field(:id, "username").set profile['username']
  @browser.text_field(:id, "password").set profile['password']

	if(profile['remember'] == true)
		@browser.checkbox(:id, "remember_me").set
	else
		@browser.checkbox(:id, "remember_me").clear
	end

  begin
    @browser.button(:name => 'commit').click
  rescue
  end

	@browser.wait_until {@browser.div(:id => 'session').exists?}

	puts 'Signin is Completed'
end

def select_username(param)
  until @browser.text_field( :id => 'desiredSN' ).visible? == false
    @browser.text_field( :id => 'desiredSN' ).set(param)
    @browser.span( :text => 'Check' ).click
    @browser.wait_until {@browser.image(:title,/Congratulations/).exist? || @browser.div(:class,'suggMid').exist?}
    if @browser.text_field( :id => 'desiredSN' ).visible? == false
      break
    else
      select_username(increament(param))
    end
  end
end

def solve_captcha_addbusiness
  image = "#{ENV['USERPROFILE']}\\citation\\crunchbase_captcha.png"
  obj = @browser.image( :xpath, '//*[@id="recaptcha_image"]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

def enter_captcha_addbusiness
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha_addbusiness

		@browser.text_field( :id, 'recaptcha_response_field').set captcha_code
		@browser.button(:name => 'commit').click
		sleep(2)	
		if not @browser.text.include? "Error with reCAPTCHA!"
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