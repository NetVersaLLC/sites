# Developer's Notes
# Good idea for listing site: mydeputy.net

# Setup
@browser = Watir::Browser.new :firefox
@browser.goto 'www.mysheriff.net'
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
  sleep(3)
  @browser.link(:text,/add new business/).click
  sleep(3)

  form = @browser.form(:name => "formSearch") 

  form.text_field(:id => 'business').set data["business_name"]
  form.text_field(:id => 'location').set data['zip']

  form.button(:value => "Search").click

  @browser.link(:text => /Add your business now/).exist?
end

def create_listing data
  @browser.link(:text => /Add your business now/).click

  form = @browser.form(:name => "formAdd") 

  @browser.text_field(:id => "CompanyName").set data["business_name"] 
  @browser.text_field(:id => "Address").set data["address1"] 
  @browser.text_field(:id => "Address2").set data["address2"]
  @browser.text_field(:id => "zip").set data["zip"] 
  @browser.text_field(:id => "phone1").set data["phone"][0]
  @browser.text_field(:id => "phone2").set data["phone"][1]
  @browser.text_field(:id => "phone3").set data["phone"][2]
  @browser.text_field(:id => "WebsiteAddress").set data["website"] 
  @browser.text_field(:id => "EmailAddress").set data["email"]

  form.text_field(:name,'City').set data["city"]
  @browser.div(:class => 'ac_results', :text => /#{data['city']}/).wait_until_present
  @browser.div(:class => 'ac_results').li(:text => /#{data['state']}/).click

  form.text_field(:name,'searchDescription').set data["category"]
  Watir::Wait.until { @browser.divs(:class => 'ac_results').length == 2 } 
  categories = @browser.divs(:class => 'ac_results')[1]
  categories.li(:text => /#{data['category']}/i).click

  form.button.click
  if @browser.text.include? "View Listing"
    self.save_account('Mysheriff', {
        "listing_url" => @browser.link(:text,/View Listing/).href,
        "status" => "Listing successfully created."
      })
    true
  else
    raise 'failed to create listing' 
  end
end

# Controller
login(data) and search_listing(data) and create_listing(data)
self.success

