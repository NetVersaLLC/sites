@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

# Temp copy from shared.rb

def sign_in( data )
@browser.goto( 'https://account.nokia.com/' )
@browser.text_field( :id => 'username').set data['username']
@browser.text_field( :id => 'password').set data['password']
@browser.button( :id => 'loginsubmit').click
end

# End temp copy from shared.rb

sign_in(data)

@browser.goto( 'http://primeplace.nokia.com/place/create' )

if @browser.link( :text => /Accept/i).exists?
	@browser.link( :text => /Accept/i).click
end

@browser.text_field( :id => 'name').when_present.set data['business']
@browser.select_list( :id => 'country').select data['country']
sleep(2)
@browser.text_field( :id => 'number').set data['address2']
@browser.text_field( :id => 'street').set data['address']
@browser.select_list( :id => 'province').select data['state_name']
@browser.text_field( :id => 'postalCode').set data['zip']
@browser.text_field( :id => 'city').set data['city']
sleep(1)

puts(data['category1'])
puts(data['category2'])
@browser.select_list( :id => 'level1Category').select data['category1']
sleep(1)
@browser.select_list( :id => 'level3Category').select data['category2']

@browser.button( :id => 'add_place').click
sleep(5)
#if @browser.link( :class => 'button big').exists?
#	@browser.link( :class => 'button big').click
#end

#Wait for Verification Page
Watir::Wait.until { @browser.text.include? "Choose a verification method" }

#Begin Postcard Verify
@browser.span(:id => 'methodPostcardTab').click
sleep(2)
@browser.text_field( :id => 'postcardFirstName').set data['fname']
@browser.text_field( :id => 'postcardLastName').set data['lname']
@browser.button( :id => 'verifyPostcard').click
true