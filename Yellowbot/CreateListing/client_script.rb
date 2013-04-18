
sign_in(data)

@browser.goto( 'http://www.yellowbot.com/submit/newbusiness' )

@browser.text_field( :name, 'name').set data['business']
@browser.text_field( :name, 'phone_number').set data['phone']
@browser.text_field( :name, 'address').set data['address']

@browser.text_field( :name, 'fax_number').set data['fax_number']

Watir::Wait.until { @browser.alert.exists? }
@browser.alert.ok

@browser.text_field( :name, 'city_name').set data['city_name']
@browser.select_list( :name, 'state').select data['state']
@browser.text_field( :name, 'zip').set data['zip']
@browser.text_field( :name, 'tollfree_number').set data['tollfree_number']
@browser.text_field( :name, 'hours_open').set data['hours_open']
@browser.text_field( :name, 'email').set data['email']
@browser.text_field( :name, 'website').set data['website']



	captcha_text2 = solve_captcha2()
	@browser.text_field( :name, 'recaptcha_response_field').set captcha_text2
	@browser.button( :name, 'subbtn').click


true