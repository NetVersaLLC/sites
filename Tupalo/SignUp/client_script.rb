@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\tupalo_captcha.png"
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
		@browser.button(:name => /commit/).click

		5.times{ break if @browser.status == "Done"; sleep 1}
		
		if not @browser.image( :src, /recaptcha/ ).exists?
			capSolved = true
		end
		
	count+=1	
	end
	if capSolved == true
		puts "Captcha solved!"
	else
		throw("Captcha was not solved")
	end
end

#Enter your email address to register
url="http://tupalo.com/en/accounts/sign_up"
@browser.goto(url)

@browser.text_field(:id => /account_email/).set "test1@test022.com"#data['email']
@browser.button(:name => /commit/).click

@browser.wait_until do
	if @browser.text.include? "My Favorites"
		return true
	elsif @browser.image( :src, /recaptcha/ ).exists?
		enter_captcha(data)
		return true
	end
end

#Watir::Wait.until { @browser.text.include? "My Favorites" }

#self.save_account("Tupalo", {:username => data[ 'email' ]})

if @chained
	self.start("Tupalo/Verify")
end
true