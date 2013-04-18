@browser.goto("https://secure.ezlocal.com/manage/login.aspx")

@browser.text_field(:name => 'txtUsername').set data['email']
@browser.text_field(:name => 'txtPassword').set data['password']

@browser.button(:name => 'btnLogin').click
Watir::Wait.until { @browser.h3(:text => 'Business Information').exists?}
@browser.text_field(:id => "txtBusinessName").set data['name']
@browser.text_field(:id => "txtBusinessPhone").set data['local_phone']
@browser.text_field(:id => "txtAddress").set data['address']
@browser.text_field(:id => "txtBusinessFax").set data['fax']
@browser.text_field(:id =>"txtCity").set data['city']
@browser.select_list(:id => "ddStates").select data['state_long']
@browser.text_field(:id => "txtZip").set data['zip']



data['hours'].each do |day|	
	theday = day[0]	
	open = day[1][0]
	closed = day[1][1]
	if open == "Closed"
		@browser.select_list(:name => "ctl00$ContentPlaceHolder1$#{day[0]}3").select "Closed"
		@browser.select_list(:name => "ctl00$ContentPlaceHolder1$#{day[0]}4").select "Closed"
	else





		if open[0,1] == "0"
      		open = open[1..-1]
    	end
    	if closed[0,1] == "0"
      		closed = closed[1..-1]
    	end
			@browser.select_list(:name => "ctl00$ContentPlaceHolder1$#{day[0]}3").select open
			@browser.select_list(:name => "ctl00$ContentPlaceHolder1$#{day[0]}4").select closed

	end


end


data['payments'].each do |pay|
	@browser.checkbox(:id => /#{pay}/).click
end



@browser.button(:id => 'bContinue').click

Watir::Wait.until{ @browser.text.include? "Your changes have been saved."}

true