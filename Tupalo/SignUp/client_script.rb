@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		#@browser.close
	end
end

#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha( button, field, image, successTrigger, failureTrigger=nil )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha(image)
    field.set captcha_code
    button.click

    30.times{ break if @browser.status == "Done"; sleep 1}
    
    unless failureTrigger.nil? or @browser.text.include? failureTrigger
      capSolved = true
    end
    
  count+=1  
  end
  if capSolved == true
    Watir::Wait.until { @browser.text.include? successTrigger }
    true
  else
    throw("Captcha was not solved")
  end
end
#END CAPTCHA

#Enter your email address to register
url="http://tupalo.com/en/accounts/sign_up"
@browser.goto(url)

@browser.text_field(:id => /account_email/).set data['email']
@browser.button(:name => /commit/).click

@browser.div(:id=>"recaptcha_image").wait_until_present
button = @browser.button(:name=>"commit")
field = @browser.text_field(:id=>"recaptcha_response_field")
image = @browser.div(:id=>"recaptcha_image").image
enter_captcha(button,field,image,"My Favorites")
if @browser.text.include? "has already been taken"
  puts "This business has already signed up to Tupalo."
  true
end


self.save_account("Tupalo", {:username => data[ 'email' ], :password => data[ 'password' ], :email => data[ 'email' ]})

if @chained
	self.start("Tupalo/Verify")
end
true