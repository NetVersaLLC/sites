sign_in(data)

@browser.goto( 'http://ebusinesspages.com/AddCompany.aspx' )

@browser.text_field( :id => 'stitle').set data['business']
@browser.text_field( :id => 'sstreet').set data['addressComb']
@browser.text_field( :id => 'szip').set data['zip']
@browser.text_field( :id => 'sphone').set data['phone']
@browser.text_field( :id => 'sfax').set data['fax']
@browser.text_field( :id => 'semail').set data['email']
@browser.text_field( :id => 'surl').set data['website']

@browser.text_field( :id => 'sCatKey').set data['category1']
@browser.button( :id => 'CatButton').click
sleep(2)
@browser.link( :text => /#{data['category1']}/i).click
sleep(1)
@browser.button( :id => 'CoButton').click

if @browser.text.include? "Update successful!"
	true
end
