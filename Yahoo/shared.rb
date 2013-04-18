def sign_in(business)
  @browser.goto('https://login.yahoo.com/')
  @browser.text_field(:id, 'username').set business['email']
  @browser.text_field(:id, 'passwd').set business['password']
  @browser.button(:id, '.save').click
end

def retry_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha
    @browser.text_field( :id => 'captchaV5Answer' ).set captcha_text
    @browser.button( :id => 'VerifyCollectBtn' ).click  # if @browser.button( :id => 'IAgreeBtn' ).exist?
    #@browser.button( :id => 'VerifyCollectBtn' ).click if @browser.button( :id => 'VerifyCollectBtn' ).exist?

     sleep(5)
    if not @browser.text.include? "Please try this code instead"
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


def solve_captcha
      file = "#{ENV['USERPROFILE']}\\citation\\yahoo_captcha.png"
      @browser.image(:class, 'captchaImage').save file
      text = CAPTCHA.solve file, :manual
  return text
end

def retry_captcha2(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha2
    @browser.text_field( :id => 'captchaV5Answer' ).set captcha_text
    @browser.checkbox( :id => 'atc' ).click
    @browser.button( :id => 'submitbtn' ).click

     sleep(5)
    if not @browser.text.include? "The CAPTCHA code you submitted was incorrect. Please enter the new CAPTCHA code."
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


def solve_captcha2
      file = "#{ENV['USERPROFILE']}\\citation\\yahoo_captcha2.png"
      @browser.image(:id, 'captchaV5ClassicCaptchaImg').save file
      text = CAPTCHA.solve file, :manual
  return text
end

