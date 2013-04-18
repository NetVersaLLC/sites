
sign_in(data)

@browser.link(:text => 'Business Dashboard').when_present.click

Watir::Wait.until { @browser.select_list(:name => 'cboBusinesses').exists? }

@browser.link(:text => 'edit profile').click

Watir::Wait.until { @browser.link(:id => '_ctl0_hlBusinessDashboard').exists? }

@browser.button(:name => 'cmdBusinessHours').click
@browser.radio(:id => '_ctl0_rbOpenOptions_2').when_present.click

hours = data['hours']
hours.each_pair do |day,hour|
	theday = day.dup.capitalize!
	if hour == "closed"
		@browser.select_list(:name => "_ctl0:ddOpen#{theday}").select "Closed"
		@browser.select_list(:name => "_ctl0:ddClose#{theday}").select "Closed"
		next
	end
		openHour = hour['open']
		closeHour = hour['close']
			if openHour[0,1] == "0"
				openHour = openHour[1..-1]
			end
			if closeHour[0,1] == "0"
				closeHour = closeHour[1..-1]
			end			
		@browser.select_list(:name => "_ctl0:ddOpen#{theday}").select openHour
		@browser.select_list(:name => "_ctl0:ddClose#{theday}").select closeHour
end

@browser.button(:name => '_ctl0:cmdEdit').click

Watir::Wait.until { @browser.link(:id => '_ctl0_hlBusinessDashboard').exists? }

@browser.button(:name => 'cmdDescription').click

@browser.text_field(:name => 'txtBody').set data['desc']

@browser.button(:id => 'cmdEdit').click

Watir::Wait.until { @browser.link(:id => '_ctl0_hlBusinessDashboard').exists? }

@browser.button(:name => 'cmdAdd').click

@browser.text_field(:name => 'txtBusinessName').when_present.set data['name']
@browser.text_field(:name => 'txtType').set data['category1']
@browser.text_field(:name => '_ctl1:txtPhone1').set data['phone']

@browser.text_field(:name => '_ctl1:txtTollFree').set data['tollfree']
@browser.text_field(:name => '_ctl1:txtFax').set data['fax']
@browser.text_field(:name => '_ctl1:txtEmail').set data['email']
@browser.text_field(:name => '_ctl0:txtAddress1').set data['address']
@browser.text_field(:name => '_ctl0:txtAddress2').set data['address2']

@browser.text_field(:name => '_ctl0:txtCity').set data['city']
@browser.select_list(:name => '_ctl0:cboState').select data['state_name']
@browser.text_field(:name => '_ctl0:txtZip').set data['zip']

@browser.button(:name => 'cmdAdd').click

Watir::Wait.until { @browser.link(:id => '_ctl0_hlBusinessDashboard').exists? }

@browser.button(:name => 'cmdPaymentOptions').click

payments = data[ 'payments' ]
payments.each do |pay|
	@browser.checkbox(:id => pay).set
end

@browser.button(:name => '_ctl0:cmdEdit').click

Watir::Wait.until { @browser.link(:id => '_ctl0_hlBusinessDashboard').exists? }

true