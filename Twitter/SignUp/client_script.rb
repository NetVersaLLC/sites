@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

#BEGIN CAPTCHA
def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\twitter_captcha.png"
  obj = @browser.image( :src, /recaptcha/ )
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
		@browser.text_field( :id, "recaptcha_response_field" ).set captcha_code
		@browser.button( :name, "submit_button").click

		sleep 10 # Got a better solution?
		
		if not @browser.text.include? "Please try again..."
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
#END CAPTCHA

@browser.goto("https://twitter.com/signup")
puts("1")
retries = 5
begin 
	puts("2")
	@browser.text_field(:name => 'user[name]').set data['fullname']
	puts("3")
	@browser.text_field(:name => 'user[email]').set data['email']
	@browser.text_field(:name => 'user[user_password]').set data['password']
	puts("4")

	while 1
		seed = rand(1000).to_s
		data['username'] = data['username'][0 .. 10]
		data['username'] = data['username']+seed

		@browser.text_field(:name => 'user[screen_name]').set data['username']
		@browser.text_field(:name => 'user[screen_name]').send_keys :tab
		sleep 2
		@browser.p(:text => 'Validating...').wait_while_present
		sleep 1
		if not @browser.text.include? "This username is already taken!"
			break
		end
	end

	@browser.checkbox(:name => 'user[remember_me_on_signup]').clear
	@browser.checkbox(:name => 'user[use_cookie_personalization]').clear

	sleep 10 # allow all the javascript validation to finish.. otherwise this button doesn't
			 # do anything
	@browser.button(:value => 'Create my account').click


	if @browser.text.include? "Are you human?"
		enter_captcha(data)
	end

rescue StandardError => e
	puts e.inspect
	if retries > 0
		retries -= 1
		retry
	else
		throw "Twitter account creation failed."
	end

end

@browser.goto("https://twitter.com/")

#sleep 2
30.times { break if (begin @browser.text.include? "Confirm your email address to access all of Twitter's features." or @browser.text.include? "Here are some people you might enjoy following." rescue Selenium::WebDriver::Error::NoSuchElementError raise "Error validating Twitter SignUp" end) == true; sleep 1 }
#Watir::Wait.until{@browser.text.include? "Confirm your email address to access all of Twitter's features." }

self.save_account("Twitter", {:username => data['username'], :password => data['password'], :twitter_page => 'http://twitter.com/'+data['username']})

@browser.goto("https://twitter.com/settings/profile")

@browser.text_field(:id, "user_url").when_present.set data['website']
@browser.button(:id, "settings_save").click

Watir::Wait.until { @browser.text.include? "Thanks, your settings have been saved." }

if @chained
	self.start("Twitter/Verify")
end

true