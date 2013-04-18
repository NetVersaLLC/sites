@browser.goto( 'http://www.localndex.com/merchant' )

@browser.text_field( :id => 'ctl00_MainContentPlaceHolder_txtEmail').set data['email']
@browser.text_field( :id => 'ctl00_MainContentPlaceHolder_txtUserPass').set data['password']
@browser.button( :id => 'ctl00_MainContentPlaceHolder_btnSignIn').click

@browser.link(:id => 'ctl00_wucHeaderProductsMenu_btnLnkLocalndex').click
@browser.link( :id => 'ctl00_MainContentPlaceHolder_repMctBusiness_ctl00_lnkManage').click

@browser.alert.ok

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusContactName').set data['name']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusContactPhone').set data['phone']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusTollFree').set data['phonetoll']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusEmail').set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusWebsite').set data['website']

@browser.button( :id => 'ctl00_ContentPlaceHolder1_btnContinue1').click

@browser.radio( :id => 'ctl00_ContentPlaceHolder1_rbtnHours').when_present.click
sleep(1)

hours = data[ 'hours' ]
hours.each_with_index do |hour, day|
	theday = hour[0]
	theday = theday[0..2]
	theday = theday.capitalize
	if hour[1][0] != "closed"
		# Is the day closed?	
		open = hour[1][0]
		openAMPM = open[-2, 2]
		close = hour[1][1]
		closeAMPM = close[-2, 2]
		open = open.gsub( / [ap]m/i, '')
		close = close.gsub( / [ap]m/i, '')
		@browser.text_field( :id => "ctl00_ContentPlaceHolder1_txt#{theday}Open").set open
		@browser.text_field( :id => "ctl00_ContentPlaceHolder1_txt#{theday}Close").set open
		@browser.select_list( :id => "ctl00_ContentPlaceHolder1_ddl#{theday}Open").select openAMPM
		@browser.select_list( :id => "ctl00_ContentPlaceHolder1_ddl#{theday}Close").select closeAMPM
	else
		@browser.checkbox( :id => "ctl00_ContentPlaceHolder1_chk#{theday}Closed").click
	end

end


payments = data['payments']

payments.each do |pay|
	@browser.checkbox( :id => "ctl00_ContentPlaceHolder1_chk#{pay}").click
end

@browser.button( :id => 'ctl00_ContentPlaceHolder1_btnContinue2').click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusServices').when_present.set data['services']
#TODO Services and Products. 

@browser.button( :id => 'ctl00_ContentPlaceHolder1_btnContinue3').click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusDescription').when_present.set data[ 'description' ]

@browser.button( :id => 'ctl00_ContentPlaceHolder1_btnContinue4').click

#TODO Category system

@browser.button( :id => 'ctl00_ContentPlaceHolder1_btnContinue5').when_present.click

if @browser.text.include? "Your information has been successfully saved"
	puts("Business claimed")
end

