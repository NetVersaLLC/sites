@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def update(data)
  @browser.goto "http://www.city-data.com/profiles/account"

  @browser.text_field(:name => 'login').set data['email']
  @browser.text_field(:name => 'pass').set data['pass']

  @browser.button(:value => 'Login').click

  @browser.button(:value => 'Edit profile').when_present.click

  @browser.text_field(:name => 'year_established').wait_until_present

  @browser.text_field(:name => 'name').set data['business']

  @browser.text_field(:name => 'addr1').set data['address1']
  @browser.text_field(:name => 'addr2').set data['address2']
  @browser.text_field(:name => 'city').set data['city']
  @browser.select_list(:name => 'state').select data['state']
  @browser.text_field(:name => 'zip').set data['zip']
  @browser.text_field(:name => 'phone').set data['phone']
  @browser.text_field(:name => 'fax').set data['fax']
  @browser.text_field(:name => 'work_hours').set data['hours']
  @browser.text_field(:name => 'year_established').set data['founded']
  @browser.select_list(:name => 'cc_accept').select data['ccaccepted']
  #@browser.select_list(:name => 'empl_num').select data['employees']
  #cats
  @browser.select_list(:name => 'cat').select data['category']

  description = data['description']
  if description.length < 349
    description = description + " " + description
  end

  @browser.textarea(:name => 'descr').set description

  @browser.button(:value => 'Save changes').click
  if @browser.text.include? "Description must be at least 350 characters long."
    raise "This customer's business description is too short, and cannot be supported by Citydata."
  end 

  @browser.button(:value => 'Edit profile').wait_until_present
end

update(data)
self.save_account("Citydata", {:status => "Listing updated successfully!"})

true
