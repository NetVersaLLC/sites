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

sign_in(data)

30.times{ break if @browser.status == "Done"; sleep 1}

@browser.link( :text => /Business Account Contact/).click

prefix=data[ 'prefix' ]
if prefix == 'Miss.'
	prefix = "Ms."
elsif not prefix.nil?
	prefix = "Select Title"	
end
@browser.select_list( :name, 'prefix' ).select prefix

@browser.text_field( :name => 'firstName' ).set data[ 'firstName' ]
@browser.text_field( :name => 'lastName' ).set data[ 'lastName' ]

@browser.text_field( :name => 'businessName' ).set data[ 'businessName' ]
@browser.text_field( :name => 'website' ).set data[ 'website' ]
@browser.text_field( :name => 'busAddress1' ).set data[ 'busAddress1' ]
@browser.text_field( :name => 'busAddress2' ).set data[ 'busAddress2' ]

@browser.text_field( :name => 'busCity' ).set data[ 'busCity' ]
@browser.select_list( :name, 'busState' ).select data[ 'busState' ]
@browser.text_field( :name => 'busZip1' ).set data[ 'busZip1' ]
# TODO: Don't show my address on my Kudzu.com profile?

@browser.text_field( :name => 'busNPA' ).set data[ 'busNPA' ]
@browser.text_field( :name => 'busNXX' ).set data[ 'busNXX' ]
@browser.text_field( :name => 'busPlusFour' ).set data[ 'busPlusFour' ]
@browser.text_field( :name => 'busExtension' ).set data[ 'busExtension' ]
@browser.text_field( :name => 'busFaxNPA' ).set data[ 'busFaxNPA' ]
@browser.text_field( :name => 'busFaxNXX' ).set data[ 'busFaxNXX' ]
@browser.text_field( :name => 'busFaxPlusFour' ).set data[ 'busFaxPlusFour' ]

data[ 'paymentTypes' ].each { |item|
  @browser.checkbox( :value => payment_types[ item ] ).set
}
data[ 'languagesSpoken' ].each { |item|
  @browser.checkbox( :value => languages_spoken[ item ] ).set
}

@browser.text_field( :name => 'yearEstablished' ).set data[ 'yearEstablished' ]
@browser.button( :name, 'nextButton' ).click

30.times { break if (begin @browser.text.include? "Edit or delete your additional locations here. Your changes will be published on Kudzu.com within 24 hours." or @browser.text.include? "An exact location for" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

if ( @browser.text.include? "Edit or delete your additional locations here. Your changes will be published on Kudzu.com within 24 hours." )
	@browser.button(:name => /editButton/i).click
	puts("Business update successful!")	
elsif ( @browser.text.include? "An exact location for" )
	@browser.button(:name, 'nextButton').click
	30.times{ break if @browser.status == "Done"; sleep 1}
	puts("Business update successful!")	
end	
true