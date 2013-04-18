sign_in(data)

@browser.goto('http://www.cornerstonesworld.com/pge/popeditinfo.php')
@browser.text_field( :id => 'cname').set data[ 'business' ]
@browser.select_list( :id => 'cat').select data['category']	
@browser.text_field( :id => 'addrcl').set data[ 'address' ]
@browser.text_field( :id => 'citycl').set data[ 'city' ]
@browser.text_field( :id => 'zipcl').set data[ 'zip' ]
@browser.select_list( :id => 'country').select data['country']
@browser.select_list( :id => 'state').when_present.select data['state']
@browser.text_field( :id => 'phonecl').set data[ 'phone' ]
@browser.text_field( :id => 'phone2cl').set data[ 'phone2' ]
@browser.text_field( :id => 'faxcl').set data[ 'fax' ]
@browser.text_field( :id => 'mphonecl').set data[ 'mobilephone' ]
@browser.text_field( :id => 'web').set data[ 'website' ]
@browser.checkbox( :id => 'agree').click

@browser.button(:name => 'save').click

Watir::Wait.until { @browser.text.include? "Here you can see a preview of your profile." }
true