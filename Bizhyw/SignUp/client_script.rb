@browser = Watir::Browser.new
at_exit do
	@browser.close
end

@browser.goto 'http://www.bizhwy.com/addlisting.php'
@browser.text_field(:name => 'bus_name').set data['business_name']
@browser.select_list(:name => 'category').select data['category']
@browser.select_list(:name => 'statename').select data['state_long']
@browser.button(:name => 'submit').click
@browser.select_list(:name => 'subcategory').select data['subcategory']
@browser.text_field(:name => 'address').set data['address']
@browser.select_list(:name => 'city').select data['city']
@browser.text_field(:name => 'zip').set data['zip']
@browser.text_field(:name => 'url').set data['company_website']
@browser.text_field(:name => 'email').set data['email']
@browser.text_field(:name => 'phone1').set data['phone1']
@browser.text_field(:name => 'phone2').set data['phone2']
@browser.text_field(:name => 'phone3').set data['phone3']
@browser.text_field(:name => 'password1').set data['password']
@browser.text_field(:name => 'password2').set data['password']
@browser.button(:name => 'submit').click
@browser.checkbox(:name => 'true_link').clear
@browser.button(:name => 'submit').click

self.save_account('Bizhyw', { :email => data['email'], :password => data['password'] })

true
