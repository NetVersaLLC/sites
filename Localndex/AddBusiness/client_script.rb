agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

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
    form.field_with(:name => /txtSecurity/).value = solve_captcha(page)
    page = form.click_button(form.button_with(:type => 'submit'))
    if page.body =~ /This is the information you entered for your business/
      capSolved = true
    elsif capRetries == 0 # B
      throw "Payload did not complete successfully due to captcha."
    else
      capRetries -= 1
    end
  end
  return page
end

page = agent.get('http://www.localndex.com/claim/addnew.aspx')
form = page.form_with(:name => 'aspnetForm')
form.field_with(:name => /BusName/).value = data['business']
form.field_with(:name => /BusAddress/).value = data['address']
form.field_with(:name => /BusCity/).value = data['city']
form.field_with(:name => /BusState/).value = data['state']
form.field_with(:name => /BusZip$/).value = data['zip']
form.field_with(:name => /BusPhone$/).value = data['phone']
form.field_with(:name => /BusTollFree$/).value = data['toll']
form.field_with(:name => /BusEmail/).value = data['email']
form.field_with(:name => /BusWebsite/).value = data['website']
form.field_with(:name => /txtReason/).value = 1
form.field_with(:name => /UserEmail/).value = data['email']
page = enter_captcha(page, data)
form = page.form_with("aspnetForm")
page = form.click_button(form.button_with(:type => 'submit'))
if page.body =~ /Thank You for Submitting/
  true
else
  throw "Payload did not submit successfully."
end