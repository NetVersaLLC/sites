def solve_captcha(page)
    captcha = page.image_with(:src => /CaptchaImg/)
    captcha.fetch.save! "#{ENV['USERPROFILE']}\\citation\\localndex_captcha.png"
    image = "#{ENV['USERPROFILE']}\\citation\\localndex_captcha.png" # Do not combine with above line
    captcha_text = CAPTCHA.solve image, :manual
    return captcha_text
end

def enter_captcha(page, data)
  capSolved = false
  capRetries = 5
  until capSolved == true # A
    form = page.form_with("aspnetForm")
    form.field_with(:name => /UserPass1/).value = data['password']
    form.field_with(:name => /UserPass2/).value = data['password']
    form.field_with(:name => /txtSecurity/).value = solve_captcha(page)
    page = form.click_button(form.button_with(:type => 'submit'))
      if page.body =~ /Thank You For Registering!/
        capSolved = true
      elsif capRetries == 0 # B
        throw "Payload did not complete successfully due to captcha."
      else
        capRetries -= 1
      end
  end
  return page
end

agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

page = agent.get('http://www.localndex.com/register.aspx')
form = page.form_with(:name => 'aspnetForm')
form.field_with(:name => /UserName/).value = data['username']
form.field_with(:name => /UserEmail/).value = data['email']
enter_captcha(page, data)
true