# Create your profile
url = 'https://register.kudzu.com/login.do'
@browser.goto(url)

# Fill Create Your Login page
  # Watir::Wait::until @browser.text.include "Create Your Login" or assert that
  # Watir::Wait::until do @browser.text.include? "agree to the terms below" end
@browser.text_field( :name => 'username' ).set data[ 'userName' ]
@browser.text_field( :name => 'password' ).set data[ 'pass' ]
@browser.button( :name, 'login' ).click

sleep 2
Watir::Wait::until {@browser.text.include? "Add Your Information"}

# Fill Add Your Information page
#Code added by Coin starts below.
#The prefix need to be modified as per the list of the table...As there is no miss all the miss are missing...
prefix= data[ 'prefix' ]
if prefix == 'Miss.'
	prefix = "Ms."
end
@browser.select_list( :name, 'prefix' ).select prefix
#Code addition/update by Coin ends here.
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
#Code logic added for fax number to be empty
fax=data['fax']
if fax != ""
	faxnpa=fax.split("-")[0]
	faxnxx=fax.split("-")[1]
	faxplusfour=fax.split("-")[2]
	@browser.text_field(:name => 'busFaxNPA' ).set faxnpa
	@browser.text_field(:name => 'busFaxNXX' ).set faxnxx
	@browser.text_field(:name => 'busFaxPlusFour' ).set faxplusfour
end
@browser.button( :name, 'nextButton' ).click

sleep 2
Watir::Wait::until{ @browser.text.include? "Choose the Correct Address" or @browser.text.include? "Pick the best place for your business"}

# Confirm on Choose the Correct Address page
if @browser.text.include? "Choose the Correct Address"
@browser.button( :name, 'nextButton' ).click
end

sleep 2
Watir::Wait::until{ @browser.text.include? "Pick the best place for your business"}

# Select on Choose Category page
@browser.select_list( :id, 'industry' ).select /#{data[ 'industry' ]}/
sleep 2
Watir::Wait.until{ @browser.select_list( :id, 'category' ).exists? }
@browser.select_list( :id, 'category' ).select /#{data[ 'category' ]}/
@browser.button( :name, 'nextButton' ).click

sleep 2
Watir::Wait::until{ @browser.text.include? "Add Specialties" }
@browser.button( :name, 'nextButton' ).click

#
sleep 2
Watir::Wait::until{ @browser.text.include? "Add Specialties" }
@browser.button( :name, 'nextButton' ).click
#

# On Add Specialties page
# TODO: Steps 1, 2, 3, 4, but probably may vary (N of 4)

# On Preview Your Profile
@browser.checkbox( :name, 'businessAgreement' ).set
@browser.button( :name, 'submitButton' ).click

puts("Business SingUp Success!")

if @chained
  self.start("Kudzu/Verify")
end
if @chained
	self.start("Kudzu/AddListing")
end
true

#Basic profile details updated!