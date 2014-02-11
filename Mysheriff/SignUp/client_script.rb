# Developer's Notes
# Good idea for listing site: mydeputy.net

# Agent Code
@browser = Watir::Browser.new :firefox
@browser.goto 'mysheriff.net/users'
at_exit{ @browser.close unless @browser.nil? }

# Classes
class IncorrectCaptcha < StandardError; end
class ExistingAccount < StandardError; end

# Methods
def solve_captcha
  captcha = @browser.img(:src,/verification/) # Finds the captcha image
  captcha.save "#{ENV['USERPROFILE']}\\citation\\mysheriff_captcha.png" # Saves it to the user's computer
  image = "#{ENV['USERPROFILE']}\\citation\\mysheriff_captcha.png" # Do not combine with above line, sets the image variable to the local image file
  captcha_text = CAPTCHA.solve image, :manual  # Solves the captcha
  return captcha_text # Returns the solve to enter_captcha method
end

def fill_form parent, vals
  fields = parent.text_fields.each{} + parent.selects.each{}
  fields.each do |field|
    case field
    when Watir::TextField
      field.set vals[field.name] rescue nil
    when Watir::Select
      field.select vals[field.name] rescue nil
    end
  end
end

def signup data
  retries ||= 2
  @browser.radio(:value,data["gender"]).when_present.click
  vals = {
    "firstname"     => data["first_name"],
    "lastname"      => data["last_name"],
    "email_address" => data["email"],
    "password"      => data["password"],
    "cmbmonth"      => data["birthday"]["month"],
    "cmbday"        => data["birthday"]["day"],
    "cmbyear"       => data["birthday"]["year"],
    "verif_box"     => solve_captcha
  }
  fill_form @browser.div(:id,'content'), vals
  @browser.div(:id,'content').text_field(:name,"City").set data["city"]
  cityList = @browser.div(:class,'ac_results')
  cityList.li(:text,/#{data["state"]}/).when_present.click rescue nil
  @browser.button(:value,/Sign Up/).click

  if @browser.text.include? "Your email address has already been used"
    raise ExistingAccount
  elsif @browser.text.include? "Please Enter the text in the image Correctly."
    raise IncorrectCaptcha
  end

  @browser.text.include? "add new business"
rescue IncorrectCaptcha
  retry if (retries -= 1) > 0
  raise IncorrectCaptcha, "Could not pass CAPTCHA."
end

# Controller
if signup(data)
self.save_account('Mysheriff', {
  :status => "Account successfully created.",
  :email => data["email"],
  :password => data["password"]
})
end