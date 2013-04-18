def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\expressupdateusa_captcha.png"
  obj = @browser.image( :xpath, '/html/body/div/div/div[2]/div/div/form/div/div/div[21]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def sign_in( data )
	@browser.goto( 'https://listings.expressupdateusa.com/Account/SignIn' )
	@browser.text_field( :name, 'Email' ).set data[ 'business_email' ]
	@browser.text_field( :name, 'Password' ).set data[ 'password' ]
	@browser.button( :id, 'SignInNowButton').click

end

def clean_time( time )
time = time.gsub( "AM", " AM")
time = time.gsub( "PM", " PM")
if time[0,1] == '0'
	time[0] = ''
end
time
end




def enter_captcha( data )

	capSolved = false
	count = 1
	until capSolved or count > 5 do
  sleep(3)
		captcha_code = solve_captcha
    puts("1")
		@browser.text_field( :id, 'Password' ).set data[ 'personal_password' ]
		puts("2")
    @browser.text_field( :id, 'ConfirmPassword' ).set data[ 'personal_password' ]  
    puts("3")
    @browser.text_field( :id, 'Captcha').set captcha_code
		puts("4")
    @browser.button( :class, 'RegisterNowButton' ).click
    puts("5")
sleep(5)
puts("6")
		if not @browser.text.include? "Check the Captcha"
    puts("7")
			capSolved = true
		end
		puts("8")
	count+=1	
	end
puts("9")
	if capSolved == true
  puts("10")
		true
    puts("11")
	else
  puts("12")
		throw("Captcha was not solved")
	end
  puts("13")
end


