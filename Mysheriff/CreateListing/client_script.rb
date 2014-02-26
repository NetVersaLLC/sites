# Developer's Notes
# Good idea for listing site: mydeputy.net

# Setup
@browser = Watir::Browser.new :firefox
@browser.goto 'mysheriff.net/users'
at_exit{ @browser.close unless @browser.nil? }

# Classes
class InvalidCredentials; end

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

def login data
  if @browser.text.include? "Logout"
    puts "Already logged in. Proceeding."
    true
  else
    vals = {
      "username" => data["email"],
      "password" => data["password"]
    }
    login_form = @browser.form(:id,"loginForm")
    fill_form login_form, vals
    login_form.button.click
    raise InvalidCredentials if @browser.text.include? "Invalid Login"
    @browser.text.include? "Logout"
  end
end

def search_listing data
  sleep 3
  @browser.link(:text,/add new business/).click
  vals = {
    "business" => data["business_name"],
    "location" => data["zip"]
  }
  fill_form @browser.div(:id,'content'), vals
  @browser.div(:id,'content').button.click
  @browser.text.include? "Thank you, your business isn't listed"
end

def create_listing data
  form = @browser.div(:id,'content')
  @browser.link(:text,/Add your business now/).click
  vals = {
    "CompanyName" => data["business_name"],
    "Address" => data["address1"],
    "Address2" => data["address2"],
    "zip" => data["zip"],
    "phone1" => data["phone"][0],
    "phone2" => data["phone"][1],
    "phone3" => data["phone"][2],
    "WebsiteAddress" => data["website"],
    "EmailAddress" => data["email"]
  }
  fill_form form, vals
  form.text_field(:name,'City').set data["city"]
  sleep 1
  @browser.div(:class,'ac_results').li(:text,/#{data["state"]}/).click
  form.text_field(:name,'searchDescription').set data["category"]
  sleep 2
  @browser.strong(:text,/#{data["category"]}/).when_present.click
  form.button.click
  if @browser.text.include? "View Listing"
    self.save_account('Mysheriff', {
        "listing_url" => @browser.link(:text,/View Listing/).href,
        "status" => "Listing successfully created."
      })
    true
  else
    false
  end
end

# Controller
if login(data) and search_listing(data) and create_listing(data)
  self.success
end
