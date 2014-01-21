@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

@browser.goto("http://www.spoke.com/companies/new")
@browser.button(:value,"Anonymous").click
@browser.text_field(:id, "recaptcha_response_field").set("esodse moved")
@browser.button(:value,"Ok").click
@browser.text_field(:id, "company_name").set data['business_name']
@browser.text_field(:id, "company_url").set data['website']
@browser.area(:id, "company_summary").set data['website']
@browser.area(:id, "company_tags").set data['tags']
@browser.text_field(:id, "company_offices_attributes_0_phone").set data['phone']
@browser.text_field(:id, "company_offices_attributes_0_address1").set data['address']
@browser.text_field(:id, "company_offices_attributes_0_city").set data['city']
@browser.select_list(:id, "company_offices_attributes_0_state").select data['state_name']
@browser.select_list(:id, "company_offices_attributes_0_country").select("United States")
@browser.button(:value,"SAVE").click
self.save_account("Spoke", {:status => "Listing posted successfully!"})
self.success
