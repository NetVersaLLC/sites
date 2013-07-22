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
# Start Sign Up process
url = 'https://register.kudzu.com/packageSelect.do'
@browser.goto(url)
@browser.button( :name, 'basicButton' ).click

# Fill Create Your Login page
  # Watir::Wait::until @browser.text.include "Create Your Login" or assert that
  # Watir::Wait::until do @browser.text.include? "agree to the terms below" end
@browser.text_field( :id => 'userName' ).set data[ 'userName' ]
@browser.text_field( :id => 'email' ).set data[ 'email' ]
@browser.text_field( :id => 'pass1' ).set data[ 'pass' ]
@browser.text_field( :id => 'pass2' ).set data[ 'pass' ]
@browser.select_list( :id, 'securityQuestion' ).select data[ 'securityQuestion' ]
@browser.text_field( :id => 'answer' ).set data[ 'answer' ]
@browser.button( :name, 'nextButton' ).click


# Fill Add Your Information page
@browser.select_list( :name, 'prefix' ).select data[ 'prefix' ]
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


Watir::Wait::until{ @browser.text.include? "Choose the Correct Address" or @browser.text.include? "Pick the best place for your business"}

# Confirm on Choose the Correct Address page
if @browser.text.include? "Choose the Correct Address"
@browser.button( :name, 'nextButton' ).click
end

Watir::Wait::until{ @browser.text.include? "Pick the best place for your business"}

# Select on Choose Category page
@browser.select_list( :id, 'industry' ).select /#{data[ 'industry' ]}/
Watir::Wait.until{ @browser.select_list( :id, 'category' ).exists? }
@browser.select_list( :id, 'category' ).select /#{data[ 'category' ]}/
@browser.button( :name, 'nextButton' ).click


Watir::Wait::until{ @browser.text.include? "Add Specialties" }
@browser.button( :name, 'nextButton' ).click


# On Add Specialties page
# TODO: Steps 1, 2, 3, 4, but probably may vary (N of 4)

Watir::Wait::until{ @browser.text.include? "Preview Your Profile" }

# On Preview Your Profile
@browser.checkbox( :name, 'businessAgreement' ).click
@browser.button( :name, 'submitButton' ).click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['userName'], 'account[password]' => data['pass'], 'account[secret_answer]' => data['answer'], 'model' => 'Kudzu'


#Kudzu.notify_of_join( key )

if @chained
  self.start("Kudzu/Verify")
end

true