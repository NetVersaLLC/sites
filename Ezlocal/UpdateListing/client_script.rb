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
	puts(pay)
	if @browser.checkbox(:id => /#{pay}/).exists? then
		@browser.checkbox(:id => /#{pay}/).clear
	end
		if pay == "Personal Checks" then
			@browser.checkbox(:id => 'chkPersonalChecks').clear
		end
		if pay == "Credit Terms" then
			@browser.checkbox(:id => 'chkCreditTerms').clear
		end
		if pay == "Financing" then
			@browser.checkbox(:id => 'chkFinancing').clear
		end
		if pay == "Money Orders" then
			@browser.checkbox(:id => 'chkMoneyOrders').clear
		end
		if pay == "Paypal" then
			@browser.checkbox(:id => 'chkPaypal').clear
		end
		if pay == "Travelers Checks" then
			@browser.checkbox(:id => 'chkTranvelersChecks').clear
		end
end
sleep(2)
data['payments'].each do |pay|
	if @browser.checkbox(:id => /#{pay}/).exists? then
		@browser.checkbox(:id => /#{pay}/).set\
	end
		if pay == "Personal Checks" then
			@browser.checkbox(:id => 'chkPersonalChecks').set
		end
		if pay == "Credit Terms" then
			@browser.checkbox(:id => 'chkCreditTerms').set
		end
		if pay == "Financing" then
			@browser.checkbox(:id => 'chkFinancing').set
		end
		if pay == "Money Orders" then
			@browser.checkbox(:id => 'chkMoneyOrders').set
		end
		if pay == "Paypal" then
			@browser.checkbox(:id => 'chkPaypal').set
		end
		if pay == "Travelers Checks" then
			@browser.checkbox(:id => 'chkTranvelersChecks').set
		end
end

@browser.select_list(:id => "ddCategory").select data['ezlocal_category1']
puts("Inserted Alias Category")

if @browser.div(:class => "tags").a(:text => "x").exists? then
@browser.div(:class => "tags").a(:text => "x").click
sleep(2)
@browser.div(:id => "main").input(:id => "btnYes").click
puts("Category Removed")
end

if @browser.div(:class => "tags").a(:text => "x").exists? then
@browser.div(:class => "tags").a(:text => "x").click
sleep(2)
@browser.div(:id => "main").input(:id => "btnYes").click
puts("Category Removed")
end

if @browser.div(:class => "tags").a(:text => "x").exists? then
@browser.div(:class => "tags").a(:text => "x").click
sleep(2)
@browser.div(:id => "main").input(:id => "btnYes").click
puts("Category Removed")
end

@browser.select_list(:id => "ddCategory").select data['ezlocal_category1']
puts("Category re-selected")

@browser.button(:id => "bContinue").click

Watir::Wait.until{ @browser.text.include? "Your changes have been saved."}

true