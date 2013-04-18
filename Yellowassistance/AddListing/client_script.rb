sign_in(data)
sleep(3)

@browser.goto('http://www.yellowassistance.com/frmBusinessUpdate.aspx')

@browser.text_field( :id => 'txtPhoneSearch').set data['phone']
@browser.button( :id => 'btnSearch').click

@browser.text_field( :id => 'txtName').when_present.set data['fullname']
@browser.text_field( :id => 'txtTitle').set data['title']
@browser.text_field( :id => 'txtEmail').set data['email']
@browser.text_field( :id => 'txtCEmail').set data['email']
@browser.text_field( :id => 'txtPhone').set data['phone']

@browser.text_field( :id => 'txtBusName').set data['business']
@browser.text_field( :id => 'txtAddress').set data['addressComb']
@browser.text_field( :id => 'txtCity').set data['city']
@browser.select_list( :id => 'ddlState').select data['state'].upcase
@browser.text_field( :id => 'txtZip').set data['zip']

@browser.text_field( :id => 'txtBusPhone').set data['phone']
@browser.text_field( :id => 'txtTollFree').set data['tollfree']
@browser.text_field( :id => 'txtBusEmail').set data['email']
@browser.text_field( :id => 'txtWebsite').set data['website']

@browser.radio( :id => 'rbtnHours').click
@browser.text_field( :id => 'txtWebsite').set data['website']


hours = data[ 'hours' ]
hours.each_with_index do |hour,day|
	theday = hour[0]
	theday = theday[0..2]
	theday = theday.capitalize
	if hour[1][0] != "closed"
		open = hour[1][0]
		openAMPM = open[-2, 2]
		close = hour[1][1]
		closeAMPM = close[-2, 2]
		open = open.gsub( / [ap]m/i, '')
		close = close.gsub( / [ap]m/i, '')		
		@browser.text_field( :id => "txt#{theday}Open").set open
		@browser.text_field( :id => "txt#{theday}Close").set close
		@browser.select_list( :id => "ddl#{theday}Open").select openAMPM		
		@browser.select_list( :id => "ddl#{theday}Close").select closeAMPM			
	else
		@browser.checkbox( :id => "chk#{theday}Closed").click
	end
end


payments = data['payments']
payments.each do |payment|
	@browser.checkbox( :id => "chk#{payment}").click
end

@browser.text_field( :id => 'txtBusDescription').set data['description']

@browser.button( :id => 'btnContinue1').click

@browser.text_field( :id => 'txtCatSearch').when_present.set data[ 'category1' ]
@browser.button( :id => 'btnCatSearch').click

@browser.select_list( :id => 'lboxAvailableCats').select data[ 'category2' ]
@browser.button( :id => 'btnAddCat').click

@browser.button( :id => 'btnContinue2').click

@browser.checkbox( :id => 'chkIAgree').click

@browser.button( :id => 'btnSubmit').click

if @browser.text.include? "Thank you for your submission!"
	true
end
