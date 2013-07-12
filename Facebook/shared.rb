def retry_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha
    @browser.text_field(:id=> 'reg_passwd__').set data['password']
    @browser.text_list(:id =>'captcha_response').set captcha_text
    @browser.button(:value =>'Sign Up Now!').click

     sleep(5)
    if not @browser.text.include? "You didn\'t correctly type the text in the security check box."
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
  image = "#{ENV['USERPROFILE']}\\citation\\google_captcha.png"
  obj = @browser.image(:src, /recaptcha\/api\/image/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def login(data)
  if not @browser.link(:text => 'Logout').exist?
  @browser.text_field(:id => 'email').set data['email']
  @browser.text_field(:id => 'pass').set data['password']
  @browser.button(:value => 'Log In').click 
  end
end
