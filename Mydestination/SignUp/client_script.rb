@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\mydestination_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="captchaCode"]' )
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
		@browser.text_field( :id, 'captcha').set captcha_code
		@browser.button( :class => 'submit').click	
		sleep(2)
		if not @browser.text.include? "The characters did not match the image. Please try again."
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

def add_business(data)
  @browser.div(:id => 'footer').when_present.link(:text => 'Join Our Directory').click
  	
  @browser.text_field(:name => 'companyName').set data[ 'business' ]
  # @browser.select(:name => 'categoryId').set data[ 'category' ]
  @browser.select_list(:id => 'categoryId').select data[ 'category' ]
  
  @browser.text_field(:name => 'contactName').set data[ 'first_name' ]
  @browser.text_field(:name => 'contactSurname').set data[ 'last_name' ]
  @browser.text_field(:name => 'contactPosition').set data[ 'address' ]
  @browser.text_field(:name => 'contactPhone').set data[ 'phone' ]
  @browser.text_field(:name => 'username').set data[ 'full_name' ]
  @browser.text_field(:name => 'email').set data[ 'email' ]
  
  @browser.text_field(:name => 'password').set data[ 'password' ]
  @browser.text_field(:name => 'confirmPassword').set data[ 'password' ]
  
  # Enter Captcha code
  enter_captcha(data)

  

   if @browser.text.include? 'Thank you for submitting, you will now be redirected to the Client Admin where you will be able to complete the listing and "Submit For Approval".'
  	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'],'account[password]' => data['password'], 'model' => 'Mydestination'
  	puts "Initial Business registration is successful"
  #else
  	#puts "Initial Business registration is Unsuccessful"
  end
end

#formError

#~ #Main Steps
#~ # Launch browser
begin

@browser.goto('http://www.mydestination.com')
rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")
  sleep(1)
  # Retry 
  retry
end

@browser.div(:id=>'ipadpopup').link(:text=>"Close").when_present.click
@browser.div(:id=>'destinationmenu').link(:text=> "#{data['continent']}").when_present.click
@browser.div(:class => 'boxholder onescroll').link(:text=> "#{data['country']}").when_present.click
@browser.div(:class => 'boxholder onescroll').link(:text=> "#{data[ 'city' ] }").when_present.click

# Add new business
add_business(data)

true
