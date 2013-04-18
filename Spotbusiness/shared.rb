def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\spotbusiness_captcha.png"
  obj = @browser.image(:src, /getcaptchatab/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def enter_captcha

  capSolved = false
  count = 1
  until capSolved or count > 5 do
  captcha_code = solve_captcha
  @browser.text_field( :name, 'captchacaptcha').set captcha_code
  @browser.button(:value => 'Register').click

    if @browser.html.include?('An email with further instructions on how to complete your registration has been sent to the email address you provided.')
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


def sign_in(data)
  @browser.goto("http://spotabusiness.com/")
  @browser.text_field(:id => 'mod_login_username').set data['username']
  @browser.text_field(:id => 'mod_login_password').set data['password']
  @browser.button(:value => 'Login').click
  
end