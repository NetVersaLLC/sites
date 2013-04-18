
# Function for increamenting username by 1
def increament(param)
  if param.match(/[0-9]/)
    alpha = param.scan(/[A-Z*._a-z-]/)
    num = param.scan(/[0-9]/)
    increament =  (num.join.to_i)+1
    name = alpha.join+increament.to_s
  else
    name = param + '1'
  end
  return name
end

# Function for selecting trying multiple user name until its available
def select_username(param)
  puts("5")
  until @browser.text_field( :id => 'desiredSN' ).visible? == false
    puts("6")
    @browser.text_field( :id => 'desiredSN' ).set(param)
    puts("7")
    @browser.span( :text => 'Check' ).click
    puts("8")
    Watir::Wait.until {@browser.image(:title,/Congratulations/).exist? || @browser.div(:class,'suggMid').exist?}
    puts("9")
    sleep(3)
    if @browser.text_field( :id => 'desiredSN' ).visible? == false
      puts("10")
      break
    else
      puts("11")
      select_username(increament(param))
    end
  end
end

# Script start from here
# Launch url


url = 'http://www.aol.com/'
@browser.goto(url)

sleep(100)

puts(".5.")
@browser.link(:name => 'om_signin').click
# step 1
puts("1")
@browser.link(:text => 'Get a Free Username').when_present.click
puts("2")
@browser.text_field( :id => 'firstName' ).set data[ 'first_name' ]
@browser.text_field( :id => 'lastName' ).set data['last_name']
puts("3")
@browser.text_field( :id => 'desiredSN' ).set data[ 'username' ]
select_username(data[ 'username' ])
@browser.text_field( :id => 'password' ).set data[ 'password' ]
@browser.text_field( :id => 'verifyPassword' ).set data[ 'password' ]
@browser.link(:id,'step-one').click
sleep(3)
#Check for error message if any
@error_msg = @browser.div(:class,'errorMsg')
if @error_msg.text == ""
	puts "Step - 1 is successful completed"
else
	throw("Dispaying Error Message:#{@browser.div(:class,'errorMsg').text}")
end

# step 2
@email = @browser.div(:id,'conf-un-pi').text
@browser.div(:id,'dobMonth_custom').click
@browser.div(:class,'selMeUlWrap').ul(:class,'selectME').link(:text,"#{data[ 'month' ] }").click
@browser.text_field(:id,'dobDay').set data[ 'day' ] 
@browser.text_field(:id,'dobYear').set data[ 'year' ] 
@browser.radio(:id,"#{data[ 'gender' ]}Choice").set
@browser.text_field(:id,'zipCode').set data[ 'zip' ]
@browser.div(:id,'acctSecurityQuestion_custom').click
@browser.div(:id,'asq-toggle-sect').div(:class,'selMeUlWrap').ul(:class,'selectME').link(:text,"#{data[ 'security_question' ] }").click
@browser.text_field(:id,'acctSecurityAnswer').set data[ 'Security_answer' ] 
@browser.link(:id,'step-two').click
 
#Check for error message
if @error_msg.text == ""
	puts "Step - 2 is successful completed"
else
	throw("Dispaying Error Message:#{@browser.div(:class,'errorMsg').text}")
end

# step 3
#captcha Code

@browser.text_field(:id,'wordVerify').focus


capSolved = false
textField = @browser.text_field(:id,'wordVerify')
theButton = @browser.link(:id,'step-three')
captchaError = @browser.div( :id, 'captchaError' )

enter_captcha( captchaError, theButton, textField)



if @error_msg.exist? == false
	puts "Step - 3 is successful completed"
else
	throw("Dispaying Error Message:#{@browser.div(:class,'errorMsg').text}")
end

if @browser.text.include? "Congratulations!"
  puts 'Successful registration'
else
	throw("Registration Failed")
end

@user_name = @browser.div(:class,'congrats-info').text

if @user_name == @email
	puts "Verified: Email is matching"
end

@browser.checkbox(:id,'dltoolbar').clear
@browser.link(:text,'OK').click

#Verify
@browser.link(:text,'Sign Out').when_present.click
@browser.link(:text,'Sign In').when_present.click
@browser.text_field(:name,'loginId').set(@user_name)
@browser.text_field(:name,'password').set data[ 'password' ]
@browser.button(:id,'submitID').click
@user_name_initial = @user_name.split('@')
@user_name_header = @user_name_initial[0].downcase

#Verify email login
if @browser.div(:id,'om_aol-jumpbar').text.include?("Welcome #{@user_name_header}")
  puts "Able to login successfully"
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => @user_name_header, 'model' => 'Aol'
  true
else
  puts "Not able to access successfully"
end


