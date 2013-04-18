link = data['link']
@browser.goto(link)

@browser.text_field( :id => 'uname' ).set data[ 'email' ]
@browser.text_field( :id => 'password' ).set data[ 'temp_password' ]
@browser.link( :text => 'sign in' ).click

@browser.h1( :text => 'Change Your Password' ).wait_until_present

@browser.text_field( :id => 'password' ).set data[ 'password' ]
@browser.text_field( :id => 'confirmPassword' ).set data[ 'password' ]
@browser.link( :text => 'continue' ).click

if @browser.p( :class => 'error-message' ).exists?
	throw ('There was a problem with the password')
end

if @browser.h1( :text => 'Success! You have claimed your business listing' ).exists?
	puts ("Success! Business is listed and claimed, adding more information...")
end

@browser.link( :text => 'continue' ).click

@browser.link( :href => "javascript:submitBPLink('bpEdit','0')" ).click

@browser.link( :href => "javascript:submitEditSummaryForm('editprofileone')" ).click


#behold this monstrosity.
if data[ 'hoursset' ]
	@browser.radio( :value => '2' ).set

if business.monday_enabled
@browser.select_list( :name => 'mondayOpen' ).set prepare_time(business.monday_open)
@browser.select_list( :name => 'mondayTo' ).set prepare_time(business.monday_close)
@browser.checkbox( :name => 'mondayselected' ).clear
end
if business.tuesday_enabled
@browser.select_list( :name => 'tuesdayOpen' ).set prepare_time(business.tuesday_open)
@browser.select_list( :name => 'tuesdayTo' ).set prepare_time(business.tuesday_close)
@browser.checkbox( :name => 'tuesdayselected' ).clear
end
if business.wednesday_enabled
@browser.select_list( :name => 'wednesdayOpen' ).set prepare_time(business.wednesday_open)
@browser.select_list( :name => 'wednesdayTo' ).set prepare_time(business.wednesday_close)
@browser.checkbox( :name => 'wednesdayselected' ).clear
end
if business.thursday_enabled
@browser.select_list( :name => 'thursdayOpen' ).set prepare_time(business.thursday_open)
@browser.select_list( :name => 'thursdayTo' ).set prepare_time(business.thursday_close)
@browser.checkbox( :name => 'thursdayselected' ).clear
end
if business.friday_enabled
@browser.select_list( :name => 'fridayOpen' ).set prepare_time(business.friday_open)
@browser.select_list( :name => 'fridayTo' ).set prepare_time(business.friday_close)
@browser.checkbox( :name => 'fridayselected' ).clear
end
if business.saturday_enabled
@browser.select_list( :name => 'saturdayOpen' ).set prepare_time(business.saturday_open)
@browser.select_list( :name => 'saturdayTo' ).set prepare_time(business.saturday_close)
@browser.checkbox( :name => 'saturdayselected' ).clear
end
if business.saturday_enabled
@browser.select_list( :name => 'sundayOpen' ).set prepare_time(business.sunday_open)
@browser.select_list( :name => 'sundayTo' ).set prepare_time(business.sunday_close)
@browser.checkbox( :name => 'sundayselected' ).clear
end
else if data[ 'hour24' ]
	@browser.radio( :value => '1' ).set
else
	@browser.radio( :value => '3' ).set
end
#Yeah.. that just happened.

if business.accepts_checks
	@browser.checkbox( :name => 'bpinfo.payments.collection[5].selected' ).set
end	
if business.accepts_mastercard
	@browser.checkbox( :name => 'bpinfo.payments.collection[1].selected' ).set
end
if business.accepts_visa
	@browser.checkbox( :name => 'bpinfo.payments.collection[2].selected' ).set
end
if business.accepts_discover
	@browser.checkbox( :name => 'bpinfo.payments.collection[4].selected' ).set
end
if business.accepts_diners
	@browser.checkbox( :name => 'bpinfo.payments.collection[9].selected' ).set
end
if business.accepts_amex
	@browser.checkbox( :name => 'bpinfo.payments.collection[0].selected' ).set
end
if business.accepts_paypal
	@browser.checkbox( :name => 'bpinfo.payments.collection[14].selected' ).set
end

@browser.text_field( :id => 'tdesc' ).set data[ 'description' ]
@browser.text_field( :name => 'bpinfo.businessSince' ).set data[ 'yearest' ]
@browser.text_field( :name => 'bpinfo.affiliations' ).set data[ 'proassoc' ]
@browser.text_field( :name => 'bpinfo.specialisations' ).set data[ 'specials' ]

@browser.button( :name => '_eventId_submit').click
