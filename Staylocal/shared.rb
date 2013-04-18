def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\staylocal_captcha.png"
  obj = @browser.image(:xpath, '//*[@id="recaptcha_image"]/img')
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
  @browser.text_field( :id, 'recaptcha_response_field').set captcha_code
  @browser.button(:id => 'edit-submit').click

    if @browser.html.include?('A validation e-mail has been sent to your e-mail address. In order to gain full access to the site, you will need to follow the instructions in that message.')
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
  @browser.goto("https://www.staylocal.org/user/login")
  @browser.text_field(:id => 'edit-name').set data['username']
  @browser.text_field(:id => 'edit-pass').set data['password']
  @browser.button(:id => 'edit-submit').click
end