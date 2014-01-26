@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

@browser.goto('http://www.localpages.com/signup/')
@browser.execute_script("
oFormObject = document.forms['login'];
oFormObject.elements['username'].value = '#{data['username']}';
oFormObject.elements['password'].value = '#{data['password']}';
")

@browser.link( :text => 'Login').click

@browser.goto("http://www.localpages.com/my_listing.php")

Watir::Wait.until { @browser.text.include? "My Business Listing" }

@browser.img(:title => 'Edit').click

sleep(2)
Watir::Wait.until { @browser.text_field( :id => 'business_name').exists? }

@browser.text_field( :id => 'business_name').set data['business']
@browser.select_list( :id => 'category_1').option(:index => 0).select
@browser.select_list( :id => 'category_1').select data['category1']
sleep(3)
@browser.select_list( :id => 'category_2').select data['category2']

@browser.text_field( :name => 'address_1').set data['address']
@browser.text_field( :name => 'address_2').set data['address2']
@browser.text_field( :name => 'city').set data['city']

@browser.select_list( :name => 'state').select data['state']
@browser.text_field( :name => 'zip').set data['zip']
@browser.text_field( :name => 'phone').set data['phone']
@browser.text_field( :name => 'website').set data['website']

if not self.logo.nil? then
@browser.file_field(:id => 'photo1').value = self.logo
end

@browser.link( :text => /Update Changes/i).click

Watir::Wait.until { @browser.text.include? "My Business Listing" }

true
