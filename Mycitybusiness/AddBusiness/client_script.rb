@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

heap = JSON.parse( data['heap'] )
@heap = JSON.parse( data['heap'] ) 
if @heap.length == 0 
  @heap = JSON.parse( "{\"listing_created\": false, \"account_verified\":false}" )
  self.save_account("Mycitybusiness", {"heap" => @heap.to_json})
end 


@browser.goto('http://mycitybusiness.net/addbusiness.php')

@browser.text_field( :name => 'company').set data['business']
@browser.text_field( :name => 'address01').set data['address']
@browser.text_field( :name => 'address02').set data['address2']
@browser.text_field( :name => 'city').set data['city']
@browser.text_field( :name => 'state').set data['state']
@browser.text_field( :name => 'zip').set data['zip']
@browser.text_field( :name => 'county').set data['county']
@browser.text_field( :name => 'phone').set data['phone']
@browser.text_field( :name => 'fax').set data['fax']
@browser.text_field( :name => 'email').set data['email']
@browser.text_field( :name => 'url').set data['website']
@browser.textarea( :name => 'descr').set data['description']
@browser.textarea( :name => 'keywords').set data['keywords']
@browser.text_field( :name => 'contactname').set data['fullname']
@browser.text_field( :name => 'company').set data['business']
@browser.text_field( :name => 'contactphone').set data['phone']
@browser.text_field( :name => 'contactemail').set data['email']

@browser.button( :value => 'Submit').click
sleep 2
Watir::Wait.until { @browser.text.include? "Thank you for adding your business to mycityBusiness.net" }

@heap['listing_created'] = true
self.save_account("Mycitybusiness", {"heap" => @heap.to_json})

if @chained
  self.start("Mycitybusiness/Verify")
end
true
