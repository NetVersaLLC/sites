require 'rubygems'
require 'watir'

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\crunchbase_captcha.png"
  obj = @browser.image( :xpath, '/html/body/div[6]/div[2]/div/form/table/tbody/tr[11]/td/div/div/table/tbody/tr[2]/td[2]/div/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha

    capSolved = false
    count = 1
    until capSolved or count > 5 do
        captcha_code = solve_captcha
        @browser.text_field( :id, 'recaptcha_response_field').set captcha_code
        @browser.button(:name => 'commit').click
        sleep(2)    
        if not @browser.text.include? "Error with reCAPTCHA!"
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

def goto_signup_page
    puts 'Loading Signup Page for Crunchbase'
    @browser.goto('http://www.crunchbase.com/account/signup')
end

@browser = Watir::Browser.new
#@browser.goto('http://www.crunchbase.com/account/signup')
goto_signup_page

@browser.text_field(:id => 'user_name').set "data['name']"
@browser.text_field(:id => 'user_username').set "data['username']"
@browser.text_field(:id => 'user_password').set "data['password']"
@browser.text_field(:id => 'user_password_confirmation').set "data['password']"
@browser.text_field(:id => 'user_email_address').set "data['email']"

solve_captcha
enter_captcha
@browser.button(:name => 'commit').click
browser.link(:href => 'http://www.crunchbase.com/account/confirmation').click
true