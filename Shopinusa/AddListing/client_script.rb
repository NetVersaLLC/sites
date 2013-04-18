puts(data[ 'category2' ])

@browser.goto( 'http://www.shopinusa.com/signup/' )

@browser.text_field( :id => 'ctl00_MainContent_companyTitle').set data[ 'business' ]
@browser.text_field( :id => 'ctl00_MainContent_streetAddress').set data[ 'addressComb' ]
@browser.text_field( :id => 'ctl00_MainContent_city').set data[ 'city' ]
@browser.select_list( :id => 'ctl00_MainContent_provinceDropDown').select data[ 'state_name' ]
@browser.text_field( :id => 'ctl00_MainContent_postalCode').set data[ 'zip' ]
@browser.text_field( :id => 'ctl00_MainContent_localPhoneNum').set data[ 'phone' ]
@browser.text_field( :id => 'ctl00_MainContent_faxNumber').set data[ 'fax' ]
@browser.text_field( :id => 'ctl00_MainContent_tollFreeNumber').set data[ 'tollfree' ]
@browser.text_field( :id => 'ctl00_MainContent_contactPerson').set data[ 'fullname' ]

@browser.text_field( :id => 'ctl00_MainContent_contactEmail').set data[ 'email' ]
@browser.text_field( :id => 'ctl00_MainContent_website').set data[ 'website' ]


@browser.link( :text => "#{data['category1']}").click
sleep(3)
@browser.link( :text => "#{data['category2']}").when_present.click

enter_captcha( data )

@browser.text_field( :id => 'ctl00_MainContent_description').set data[ 'description' ]

@browser.text_field( :id => 'ctl00_MainContent_productDataList_ctl01_productTextBox').set data[ 'category1' ]
@browser.text_field( :id => 'ctl00_MainContent_productDataList_ctl02_productTextBox').set data[ 'category2' ]
@browser.text_field( :id => 'ctl00_MainContent_productDataList_ctl03_productTextBox').set data[ 'category3' ]
@browser.text_field( :id => 'ctl00_MainContent_productDataList_ctl04_productTextBox').set data[ 'category4' ]
@browser.text_field( :id => 'ctl00_MainContent_productDataList_ctl05_productTextBox').set data[ 'category5' ]

hours = data[ 'hours' ]
hours.each_with_index do |hour,day|
	theday = hour[0]
	theday = theday[0..2]
	if hour[1][0] != "closed"
		if theday == "tue"
			theday = "tues"
		end
		if theday == "thu"
			theday = "thur"
		end
		if not @browser.checkbox( :id => "ctl00_MainContent_customBusinessHours_#{theday}CheckBox").set?
			@browser.checkbox( :id => "ctl00_MainContent_customBusinessHours_#{theday}CheckBox").click
			sleep(3)
		end
		if theday == "thur"
			theday = "thurs"
		end

		theday = theday.capitalize
		# Is the day closed?	
		open = hour[1][0]
		openAMPM = open[-2, 2]
		close = hour[1][1]
		closeAMPM = close[-2, 2]
		open = open.gsub( / [ap]m/i, '')
		close = close.gsub( / [ap]m/i, '')		
		openHour = open[0,2]
		closeHour = close[0,2]
		openMin = open[-2,2]
		closeMin = close[-2,2]
		if openAMPM == "am"
			openAMPM = 0
		else
			openAMPM = 1
		end
		if closeAMPM == "am"
			closeAMPM = 0
		else
			closeAMPM = 1
		end
		
		if openHour[0,1] == "0"
			openHour = openHour[1,1]
		end
		
		if closeHour[0,1] == "0"
			closeHour = closeHour[1,1]
		end
		

		@browser.select_list( :id => "ctl00_MainContent_customBusinessHours_open#{theday}HourDropDownList").select openHour
		@browser.select_list( :id => "ctl00_MainContent_customBusinessHours_open#{theday}MinDropDownList").select openMin
		@browser.select_list( :id => "ctl00_MainContent_customBusinessHours_close#{theday}HourDropDownList").select closeHour
		@browser.select_list( :id => "ctl00_MainContent_customBusinessHours_close#{theday}MinDropDownList").select closeMin
		if theday == "Thurs"
			theday = "Thur"
		end

		@browser.radio( :id => "ctl00_MainContent_customBusinessHours_open#{theday}RadioButtonList_#{openAMPM}").click
		@browser.radio( :id => "ctl00_MainContent_customBusinessHours_close#{theday}RadioButtonList_#{closeAMPM}").click		
	else
		
		if theday == "thu"
			theday = "thur"
		end

			@browser.checkbox( :id => "ctl00_MainContent_customBusinessHours_#{theday}CheckBox").click
			puts("clicked the checkbox")
			sleep(3)		
	end

end


payments = data['payments']
payments.each do |payment|
	@browser.checkbox( :id => "ctl00_MainContent_ctlPayment_paymentCheckBoxList_#{payment}").click

end

@browser.button( :id => 'ctl00_MainContent_submitButton').click
sleep 3
# JavaScript Error: "e is null"
# The site has an unhandled javascript exception that causes selenium to freak out.
# The bgin/rescue allows the script to finish, as a work around for now.
begin
	@browser.goto('http://www.shopinusa.com/signup/Preview.aspx')
rescue Exception => e
	puts(e)
end


Watir::Wait.until { @browser.text.include? "Congratulations! Your free listing has been successfully submitted for review." }

true

