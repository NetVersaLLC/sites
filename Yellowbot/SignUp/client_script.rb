@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  sleep(3)
  CAPTCHA.solve image, :manual
end


def sign_up(data)
  @browser.goto( "https://www.yellowbot.com/signin/register" )

  @browser.text_field( :id => 'reg_email' ).set data[ 'email' ]
  @browser.text_field( :id => 'reg_email_again' ).set data[ 'email' ]
  @browser.text_field( :id => 'reg_name' ).set data[ 'username' ]
  @browser.checkbox( :name => 'tos' ).set
  @browser.checkbox( :name => 'opt_in' ).clear

  5.times do 
    captcha_text = solve_captcha( @browser.div(:id=>"recaptcha_image").image )

    @browser.text_field(:id => "recaptcha_response_field").set captcha_text
    @browser.text_field( :id => 'reg_password' ).set data[ 'password' ]
    @browser.text_field( :id => 'reg_password2' ).set data[ 'password' ]

    @browser.button(:name => "subbtn").click

    break if @browser.h2(:text => "Welcome to YellowBot!").exist?
  end

   @browser.h2(:text => "Welcome to YellowBot!").exist?
end
 

if sign_up(data)
  self.save_account("YellowBot", { :email => data['email'],:username => data['username'], :password => data['password']})
  if @chained
    self.start("Yellowbot/Verify")
  end
else
  if @chained
    self.start("Yellowbot/SignUp", 15)
  end
  throw "Incorrect CAPTCHA, retrying"
end
