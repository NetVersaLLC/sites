@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		#@browser.close
	end
end

<<<<<<< HEAD
#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
=======
def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\tupalo_captcha.png"
  obj = @browser.image( :src, /recaptcha/ )
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


<<<<<<< HEAD
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
=======
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
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3

#Enter your email address to register
url="http://tupalo.com/en/accounts/sign_up"
@browser.goto(url)

@browser.text_field(:id => /account_email/).set "test1@test022.com"#data['email']
@browser.button(:name => /commit/).click

<<<<<<< HEAD
@browser.div(:id=>"recaptcha_image").wait_until_present
button = @browser.button(:name=>"commit")
field = @browser.text_field(:id=>"recaptcha_response_field")
image = @browser.div(:id=>"recaptcha_image").image
enter_captcha(button,field,image,"My Favorites")
if @browser.text.include? "has already been taken"
  puts "This business has already signed up to Tupalo."
  true
end

=======
@browser.wait_until do
	if @browser.text.include? "My Favorites"
		return true
	elsif @browser.image( :src, /recaptcha/ ).exists?
		enter_captcha(data)
		return true
	end
end

#Watir::Wait.until { @browser.text.include? "My Favorites" }
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3

#self.save_account("Tupalo", {:username => data[ 'email' ]})

if @chained
	self.start("Tupalo/Verify")
end
true