@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end
<<<<<<< HEAD
#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
=======

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowbot_captcha.png"
  obj = @browser.image( :xpath, "/html/body/div[3]/div/div[2]/div/div/div/div/div/div[2]/form/fieldset/div/div/table/tbody/tr[2]/td[2]/div/img" )
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
    
=======
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

  
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3
  count+=1  
  end
  if capSolved == true
<<<<<<< HEAD
    Watir::Wait.until { @browser.text.include? successTrigger }
=======
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3
    true
  else
    throw("Captcha was not solved")
  end
end
<<<<<<< HEAD
#END CAPTCHA
=======
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3

@browser.goto( "https://www.yellowbot.com/signin/register" )

@browser.text_field( :id => 'reg_email' ).set data[ 'email' ]
@browser.text_field( :id => 'reg_email_again' ).set data[ 'email' ]

@browser.text_field( :id => 'reg_name' ).set data[ 'username' ]
@browser.text_field( :id => 'reg_password' ).set data[ 'password' ]
@browser.text_field( :id => 'reg_password2' ).set data[ 'password' ]

@browser.checkbox( :name => 'tos' ).set
@browser.checkbox( :name => 'opt_in' ).clear

button = @browser.button(:class => "submitBtnSignin")
image = @browser.div(:id=>"recaptcha_image").image
field = @browser.text_field(:id => "recaptcha_response_field")

begin
  enter_captcha(button,field,image,"Welcome to YellowBot!")
rescue
  if @browser.text.include? "Please correct the errors below"
    self.start("Yellowbot/SignUp")
    throw "Incorrect CAPTCHA, retrying"
  end
end


self.save_account("Site", { :email => data['email'], :password => data['password']})
if @chained
  self.start("Yellowbot/Verify")
end


<<<<<<< HEAD
true
=======
	enter_captcha( data )
  
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'YellowBot'
  
  if @chained
	  self.start("Yellowbot/Verify")
	end
  
  
  true
>>>>>>> 6164403d849d3306165e3925f0801ceb9ea071a3
