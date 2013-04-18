sign_in(data)

@browser.goto('http://www.digabusiness.com/submit.php')

@browser.radio( :id => 'LINK_TYPE_NORMAL').click
@browser.text_field( :name => 'TITLE').set data['business']
@browser.text_field( :name => 'URL').set data['website']
@browser.text_field( :name => 'DESCRIPTION').set data['description']
@browser.text_field( :name => 'OWNER_NAME').set data['fullname']
@browser.text_field( :name => 'OWNER_EMAIL').set data['email']
@browser.text_field( :name => 'ADDRESS').set data['addressComb']
@browser.text_field( :name => 'CITY').set data['city']
@browser.text_field( :name => 'STATE').set data['state_name']
@browser.text_field( :name => 'ZIP').set data['zip']
@browser.text_field( :name => 'PHONE_NUMBER').set data['phone']

payments = data['payments']
payments.each do |pay|
	@browser.checkbox( :id => /#{pay}/i).click
end

@browser.span( :id => 'toggleCategTree').click
sleep(3)
@browser.div( :title => data[ 'category1' ]).click
sleep(3)
@browser.div( :title => data[ 'category2' ]).click
sleep(3)

enter_captcha( data )

Watir::Wait.until { @browser.text.include? "We got your submission!"}
true