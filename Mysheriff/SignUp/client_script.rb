# Developer's Notes
# Good idea for listing site: mydeputy.net

# Agent Code
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

# Classes
class IncorrectCaptcha < StandardError
end

# Methods
def solve_captcha(page)
  captcha = page.image_with(:src => /verificationimage/) # Finds the captcha image
  captcha.fetch.save! "#{ENV['USERPROFILE']}\\citation\\mysheriff_captcha.png" # Saves it to the user's computer
  image = "#{ENV['USERPROFILE']}\\citation\\mysheriff_captcha.png" # Do not combine with above line, sets the image variable to the local image file
  captcha_text = CAPTCHA.solve image, :manual # Solves the captcha
  return captcha_text # Returns the solve to enter_captcha method
end

def enter_captcha(page, form, data)
  capRetries ||= 5 # Sets total retries once
  form.verif_box = solve_captcha(page) # Enters solved captcha data into the captcha field
  page = form.click_button(form.button_with(:type => 'submit')) # Submits the form
  if page.body.include?("Please Enter the text in the image Correctly.") # Checks to see if we failed the captcha
    raise IncorrectCaptcha
  elsif page.body.include? 'Nice to see you today!' # Otherwise, checks to see if we're on the right page afterwards
    true
  else # Fail if we get an unhandled page or error
    raise "Unexpected result after captcha."
  end
rescue IncorrectCaptcha
  retry unless (capRetries -= 1).zero?
  if @chained
    self.start("Mysheriff/SignUp")
  end
  self.failure("Captcha failed, re-chaining...")

rescue => e
  retry unless (capRetries -= 1).zero? # Retry unless we've tried 5 times already
  self.failure(e)
else
  if @chained
    self.start("Mysheriff/AddListing")
  end
  self.save_account('Mysheriff', {:email => data['email'], :password => data['password'], :status => "Account created, posting listing..."})
  self.success # Prevents self.success from being called in the event of a self.failure
end

def signup(data, agent)
  # Goto webpage, grab form
  page = agent.get('http://www.mysheriff.net/users/signup/')
  form = page.form_with('Form1')
  # Set gender radio button
  form.radiobutton_with(:value => data['gender']).check
  # Set basic information fields
  form.firstname = data['first_name']
  form.lastname = data['last_name']
  form.email_address = data['email']
  form.password = data['password']
  form.City = data['city']
  # Set birthday via select lists
  form.field_with('cmbmonth').value = data['birthday_month']
  form.field_with('cmbday').value = data['birthday_day']
  form.field_with('cmbyear').value = data['birthday_year']
  # Solve captcha
  enter_captcha(page, form, data)
end

# Controller
self.save_account('Mysheriff', {:status => "Account creation pending."})
signup(data, agent)