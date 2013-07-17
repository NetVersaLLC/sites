sign_in(data)

@browser.goto( 'http://ebusinesspages.com/AddCompany.aspx' )

retries = 5
begin
@browser.text_field( :id => 'stitle').set data['business']
@browser.text_field( :id => 'sstreet').set data['addressComb']
@browser.text_field( :id => 'szip').set data['zip']
@browser.text_field( :id => 'sphone').set data['phone']
@browser.text_field( :id => 'sfax').set data['fax']
@browser.text_field( :id => 'semail').set data['email']
@browser.text_field( :id => 'surl').set data['website']

if @browser.text_field( :id => 'sCatKey').exists?
@browser.text_field( :id => 'sCatKey').set data['category1']
@browser.button( :id => 'CatButton').click
sleep(2)
@browser.link( :text => /#{data['category1']}/i).click
sleep(1)
end
@browser.button( :id => 'CoButton').click
rescue
	if retries > 0 then
	retry
	retries -= 1
	end
end

if @browser.text.include? "Update successful!"
	true
end