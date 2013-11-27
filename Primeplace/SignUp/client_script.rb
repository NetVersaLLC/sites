@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

# Start temp copy from shared.rb

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\primeplace_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="captchaImage"]' )
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
		@browser.button( :id => 'submit').click	
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

# End temp copy from shared.rb

@browser.goto( 'https://account.nokia.com/acct/register?serviceId=PrimePlaces' ) 
@browser.text_field( :id => 'email').set data['email']
@browser.text_field( :id => 'newPassword').set data['password']
@browser.text_field( :id => 'newPasswordVerify').set data['password']
@browser.select_list( :id => 'country').select data['country']
@browser.select_list( :id => 'dobMonth').select data['birth1'].sub(/^0/, "")
@browser.select_list( :id => 'dobDay').select data['birth2'].sub(/^0/, "")
@browser.select_list( :id => 'dobYear').select data['birth3'].sub(/^0/, "")


enter_captcha( data )

if @browser.text.include? "You've successfully created a Nokia account. You can start exploring Nokia services right now."

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Primeplace'

	if @chained
		self.start("Primeplace/AddListing")
	end
	true
end

