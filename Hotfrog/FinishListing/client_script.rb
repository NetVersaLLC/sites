#Define some stuff, go places
retries = 5
begin
url = "http://www.hotfrog.com/Login.aspx"
@browser.goto(url)

#Put in some credentials, click a button
@browser.text_field(:name, /EmailAddress/).set data['email']
@browser.text_field(:name, /Password/).set data['password']
@browser.span(:text, /Login/).click

#Let's make sure we're in the right place
sleep 2
Watir::Wait.until { @browser.text.include? "My dashboard" }

#Start adding some minor stuff
@browser.link(:id, /FaxHyperLink/).click
Watir::Wait.until { @browser.text.include? "Fax number" }
@browser.text_field(:name, /txtFax/).set data['fax']
@browser.text_field(:name, /txtPhone/).set data['phone'] #Just in case
@browser.checkbox(:id, /NoTelemarketers/).set #Spam B-GONE

#Check those payment details
@browser.link(:id, /EditPaymentDetails/).click

sleep 2
Watir::Wait.until { @browser.text.include? "Payment options"}

data[ 'payments' ].each{ | pay |
    @browser.checkbox( :id => pay ).set
  }

@browser.span(:text, /Submit/).click

#We're coming full circle.
sleep 2
Watir::Wait.until { @browser.text.include? "Business details" }

#Set trading hours
@browser.link(:id, /EditOpeningHours/).click
@browser.radio(:id, /SpecifiedHours_1/).set
@browser.checkbox(:id, /DayRepeater/).clear #Clear closed days


if data['24hours'] == true
	@browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl00_OpeningTime").select "12:00 AM"
	@browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl00_ClosingTime").select "12:00 AM"
	@browser.link( :id, "ApplyToAll").click
	@browser.text_field(:name, /HoursDescription/).set "Open 24/7"
else
puts"1"
count = 0
	until count > 5
		puts"2"
	hours = data[ 'hours' ]
	hours.each_with_index do |hour, day|
		puts"3"
		theday = hour[0]	
		if hour[1][0] != "closed"
			# Is the day closed?	
			puts"4"
			open = hour[1][0]
			openAMPM = open[-2, 2]
			close = hour[1][1]
			closeAMPM = close[-2, 2]
	
	    if open.chars.first == "0"
	    	puts"5"
	      open[0] = ""
	    end
	    if close.chars.first == "0"
	    	puts"6"
	      close[0] = ""
	    end
	    puts"7"
	    	if @browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_OpeningTime").visible?
				@browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_OpeningTime").select open.upcase
			end
			puts"8"
			if @browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_ClosingTime").visible?
				@browser.select_list( :id, "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_ClosingTime").select close.upcase
			end
			puts"9"
			count += 1
		else
			puts"10"
			if @browser.checkbox( :id => "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_Closed").visible?
				@browser.checkbox( :id => "ctl00_contentSection_ctrlTradingHours_DayRepeater_ctl0#{count}_Closed").set
			end
			puts"11"
			count += 1
		end
	
	end
end
end

@browser.span(:text, /Submit/).click

#Did we complete the form?
sleep 2
Watir::Wait.until { @browser.text.include? "Business details" }
@browser.span(:text, /Submit/).click
if @browser.text.include? "Do you want to continue?" then
	@browser.text_field(:name, /txtPhone/).set data['phone']
	@browser.span(:text, /Submit/).click
end

#Not yet fully supported
#Add a service to flesh it out a bit, and bug out.
#@browser.link(:title, /Add your products and services (5+)/).click


#Looks like we could use some imagery.
#@browser.link(:title, /Add your business images/).click
#Watir::Wait.until { @browser.text.include? "Upload image" }
#if self.logo.nil? then
#	puts("No Logo Found")
#else
#@browser.file_field(:name, /userfile/).set self.logo
#
#	while @browser.div(:id, /uploadProcessBar/).size > 0
#		sleep(1)
#	end
#end
#count2 = 0
#if self.images.nil? then
#	puts("No Images Found")
#else
#	until count2 > self.images.length
#	@browser.file_field(:name, /userfile/).set self.images[count2]
#		while @browser.div(:id, /uploadProcessBar/).size > 0
#		sleep(1)
#		end
#	count2 += 1
#	end
#end

#We're done here
puts("FinishListing Complete")
rescue Exception => e
	puts e.inspect
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