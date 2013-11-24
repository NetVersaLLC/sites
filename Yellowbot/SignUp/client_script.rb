@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowbot_captcha.png"
  obj = @browser.image( :xpath, "/html/body/div[3]/div/div[2]/div/div/div/div/div/div[2]/form/fieldset/div/div/table/tbody/tr[2]/td[2]/div/img" )
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
      @browser.text_field( :id => 'reg_password' ).set data[ 'password' ]
      @browser.text_field( :id => 'reg_password2' ).set data[ 'password' ]  
    @browser.text_field( :id => 'recaptcha_response_field' ).set captcha_code
    @browser.button( :name => 'subbtn' ).click

    if not @browser.text.include? "Please correct the errors below and resubmit"
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

@browser.goto( "https://www.yellowbot.com/signin/register" )

  @browser.text_field( :id => 'reg_email' ).set data[ 'email' ]
  @browser.text_field( :id => 'reg_email_again' ).set data[ 'email' ]

  @browser.text_field( :id => 'reg_name' ).set data[ 'username' ]
  @browser.text_field( :id => 'reg_password' ).set data[ 'password' ]
  @browser.text_field( :id => 'reg_password2' ).set data[ 'password' ]
  
  @browser.checkbox( :name => 'tos' ).set
  @browser.checkbox( :name => 'opt_in' ).clear

	enter_captcha( data )
  
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'YellowBot'
  
  if @chained
	  self.start("Yellowbot/Verify")
	end
  
  
  true