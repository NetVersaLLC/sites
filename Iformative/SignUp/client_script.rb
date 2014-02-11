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
def signup data
  @browser.link(:text,/MY ACCOUNT/).when_present.click
  @browser.link(:text,/Register/).when_present.click
  fill_form @browser.div(:id,'register').when_present, {
    "nick"  => data["username"],
    "email" => data["email"],
    "pass"  => data["password"]
  }
  @browser.button(:class,"btn-register").click
  sleep 5 # Watir doesn't know we're waiting for a new page, so wait ourselves
  @browser.text.include? "Logout"
end

# Controller
if signup data
  self.save_account("Iformative", {
    "status"    => "Account successfully created.",
    "username"  => data["username"],
    "email"     => data["email"],
    "password"  => data["password"]
  })
  self.success
else
  self.failure
end