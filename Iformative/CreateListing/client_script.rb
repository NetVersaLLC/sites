# Setup
@browser = Watir::Browser.new
@browser.goto 'http://www.iformative.com/review/request/'
at_exit do @browser.close unless @browser.nil?; end

# Helpers
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

# Payload
def login data
  @browser.link(:text,"MY ACCOUNT").click
  fill_form @browser.div(:id,"login").when_present, {
    "email" => data["email"],
    "pass" => data["password"]
  }
  @browser.div(:id,"login").button.when_present.click
  sleep 5
  @browser.text.include? "Logout"
end

def add_listing data
  fill_form @browser.table(:class,"frame-c"), {
    "product"   => data["business_name"],
    "business"  => data["business_name"],
    "zip"       => data["zip"],
    "address"   => data["address"],
    "phone"     => data["phone"],
    "web"       => data["website"],
    "city"      => [data["city"],data["state"]].join(", "),
    "category"  => data["category"]
  }
  @browser.button(:class,'btn-submit').click
  sleep 5
  @browser.text.include? data["business_name"]
end

# Controller
if login(data) and add_listing(data)
  self.save_account("Iformative", {
      "status" => "Listing successfully created.",
      "listing_url" => @browser.url
    })
  self.success
else
  self.failure
end