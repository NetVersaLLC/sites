payment_types = { 
	'AmericanExpress' => '673', 
	'CashOnly' => '320360', 
	'DebitCard' => '320361',
  	'DinnersClub' => '677', 
	'Discover' => '676', 
	'MasterCard' => '674', 
	'MoneyOrders' => '325481',
  	'Paypal' => '325480', 
  	'PersonalChecks' => '678', 
	'Visa' => '675' 
}

languages_spoken = { 
	'English' => '700', 
	'French' => '718', 
	'Korean' => '729', 
	'Spanish' => '701',
    	'Other' => '320362' 
}

# Create your profile
@browser.goto('https://register.kudzu.com/login.do')
30.times{ break if @browser.status == "Done"; sleep 1}
@browser.text_field( :name => 'username' ).set data[ 'userName' ]
@browser.text_field( :name => 'password' ).set data[ 'pass' ]
@browser.button( :name, 'login' ).click
@browser.goto('https://register.kudzu.com/location.do')
30.times{ break if @browser.status == "Done"; sleep 1}
data[ 'paymentTypes' ].each { |item|
  @browser.checkbox( :value => payment_types[ item ] ).set
}
data[ 'languagesSpoken' ].each { |item|
  @browser.checkbox( :value => languages_spoken[ item ] ).set
}
@browser.text_field( :name => 'yearEstablished' ).set data[ 'yearEstablished' ]
@browser.button( :name, 'nextButton' ).click
30.times{ break if @browser.status == "Done"; sleep 1}
true