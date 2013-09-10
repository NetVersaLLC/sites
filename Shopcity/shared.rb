def sign_in(data)
	@browser.goto("http://www.shopcity.com/map/mapnav_locations.cfm?")
	@browser.link(:text => /#{data['country']}/).when_present.click
	@browser.link(:text => /#{data['state']}/).when_present.click
	@browser.link(:text => /#{data['cityState']}/).when_present.click	
	@browser.link(:title => 'Login').when_present.click
  30.times { break if @browser.status == "Done"; sleep 1 }
	@browser.text_field(:name => 'email').when_present.set data['email']
	@browser.text_field(:name => 'pw').set data['password']
	@browser.link(:text => "Sign Me In").click
  30.times { break if @browser.status == "Done"; sleep 1 }
end

def fill_payment_methods(data)
  payments = data['payments']
  payments.each do |payment|
    @browser.checkbox(:id => payment).click
  end
end

def fill_logo(data)
  unless self.logo.nil? 
    @browser.file_field(:name => 'photo01').set self.logo
  else
    @browser.file_field(:name => 'photo01').set self.images.first unless self.images.empty?
  end
  30.times { break if @browser.status == "Done"; sleep 1 }
end

def fill_contact_info(data)
  @browser.text_field(:name => 'businessname').when_present.set data['business']
  @browser.text_field(:name => 'contact').set data['fulleName']
  @browser.text_field(:name => 'address1').set data['address']
  @browser.text_field(:name => 'address2').set data['address2']
  @browser.text_field(:name => 'city').set data['city']
  @browser.text_field(:name => 'province').set data['state_name']
  @browser.text_field(:name => 'country').set data['country']
  @browser.text_field(:name => 'postal').set data['zip']
  @browser.text_field(:name => 'phone').set data['phone']
  @browser.text_field(:name => 'fax').set data['fax']
  @browser.text_field(:name => 'tollfree').set data['tollfree']
  @browser.text_field(:name => 'email').set data['email']
end

def fill_categories(data)
  @browser.text_field(:id => 'searchCategories').set data['category1']
  sleep 5
  @browser.select_list(:id => 'SelectList').option(:index => 0).click
  @browser.img(:title => 'Add to List').click
  30.times { break if @browser.status == "Done"; sleep 1 }
end

def fill_titles(data)
  @browser.text_field(:name => 'sitetitle').set data['business']
end