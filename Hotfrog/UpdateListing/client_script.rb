#Define some stuff, go places
retries = 5
begin
@browser = Watir::Browser.new
url = "http://www.hotfrog.com/Login.aspx"
@browser.goto(url)

#Put in some credentials, click a button
@browser.text_field(:name, /EmailAddress/).set data['email']
@browser.text_field(:name, /Password/).set data['password']
@browser.span(:text, /Login/).click

#Let's make sure we're in the right place
Watir::Wait.until { @browser.text.include? "Best work" }

#Start Updating
@browser.link(:id, /CompanyDetailsControl/).click
Watir::Wait.until { @browser.text.include? "Business email" }
@browser.text_field(:name, /txtBusinessName/).set data['business']
@browser.text_field(:name, /txtStreetAddress/).set data['street']
@browser.text_field(:name, /txtSuburb/).set data['city']
@browser.send_keys :enter
@browser.select_list(:name => /State/).option(:value => data['state']).select
@browser.text_field(:name, /txtPostcode/).set data['zip']
@browser.text_field(:name, /txtPhone/).set data['phone']
@browser.text_field(:name, /txtFax/).set data['fax']
@browser.text_field(:name, /txtWebsite/).set data['website']
@browser.text_field(:name, /txtEmail/).set data['email']
@browser.span(:text, /Submit/).click
Watir::Wait.until { @browser.text.include? "Best work" }
@browser.link(:id, /CompanyDetailsControl/).click
Watir::Wait.until { @browser.text.include? "Edit payment details" }
@browser.link(:id, /EditPaymentDetails/).click
Watir::Wait.until { @browser.text.include? "Payment options"}
@browser.checkboxes.each { |checkbox| checkbox.clear }

data[ 'payments' ].each{ | pay |
    @browser.checkbox( :id => pay ).set
  }

@browser.span(:text, /Submit/).click
Watir::Wait.until { @browser.text.include? "Edit trading hours" }
@browser.link(:id, /EditOpeningHours/).click
@browser.radio(:id, /SpecifiedHours_1/).set
@browser.checkbox(:id, /DayRepeater/).clear

if data['24hours'] == true
	@browser.select_list(:name, "ctl00$contentSection$ctrlTradingHours$DayRepeater$ctl00$OpeningTime").option(:value, "12:00 AM").select
	@browser.select_list(:name, "ctl00$contentSection$ctrlTradingHours$DayRepeater$ctl00$ClosingTime").option(:value, "12:00 AM").select
	@browser.link(:id, /ApplyToAll/).click
	@browser.textarea(:name, /HoursDescription/).set "Open 24/7"
else

count = 0
	until count > 5
	hours = data[ 'hours' ]
	hours.each_with_index do |hour, day|
		theday = hour[0]	
		if hour[1][0] != "closed"
			# Is the day closed?	
			open = hour[1][0]
			openAMPM = open[-2, 2]
			close = hour[1][1]
			closeAMPM = close[-2, 2]
	
	    if open.chars.first == "0"
	      open[0] = ""
	    end
	    if close.chars.first == "0"
	      close[0] = ""
	    end
	    
			@browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_OpeningTime").select open.upcase
			@browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_ClosingTime").select close.upcase
		else
			@browser.checkbox( :id => "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_Closed").set
		end
	count += 1
	end
end
end

@browser.span(:text, /Submit/).click
sleep(4) #Watir::Wait fails here
@browser.span(:text, /Submit/).click
sleep(4)
@browser.link(:id, /KeywordsPreviewControl/).click
sleep(4)
@popup = @browser.frame(:xpath, '//*[@id="fancybox-frame"]')
licount = @popup.lis(:xpath, '//*[@id="KeywordsUL"]/li').count
puts("#{licount} keywords to remove")
clickedcount = 0
until clickedcount == licount
@popup.li(:xpath, '//*[@id="KeywordsUL"]/li[1]').click
clickedcount += 1
end
count = 0
until count == data['keywords'].length
@popup.text_field(:name, /KeywordText/).set data['keywords'][count]
@popup.button(:name, /AddKeywordButton/).click
count += 1
sleep(1)
end
@popup.span(:text, /Submit/).click
sleep(2)
@browser.link(:id, /CompanyDescriptionControl/).click
Watir::Wait.until { @browser.text.include? "Number of characters left" }
@browser.textarea(:name, /txtDescription/).set data['description']
@browser.span(:text, /Submit/).click
Watir::Wait.until { @browser.text.include? "Best work" }
puts("UpdateListing Success")
rescue
	if retries == 0
		puts("Failed after five retries")
		false
	end
	puts("Something went wrong, retrying in two seconds...")
	sleep(2)
	retry
	retries -= 1
end
true