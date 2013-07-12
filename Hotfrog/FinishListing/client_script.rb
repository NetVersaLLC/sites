#Define some stuff, go places
@browser = Watir::Browser.new
url = "http://www.hotfrog.com/Login.aspx"
@browser.goto(url)

#Put in some credentials, click a button
@browser.text_field(:name, /EmailAddress/).set data['email']
@browser.text_field(:name, /Password/).set data['password']
@browser.span(:text, /Login/).click

#Let's make sure we're in the right place
Watir::Wait.until { @browser.text.include? "My dashboard" }

#Start adding some minor stuff
@browser.link(:id, /FaxHyperLink/).click
Watir::Wait.until { @browser.text.include? "Fax number" }
@browser.text_field(:name, /txtFax/).set data['fax']
@browser.text_field(:name, /txtPhone/).set data['phone'] #Just in case
@browser.checkbox(:id, /NoTelemarketers/).set #Spam B-GONE

#Check those payment details, Doctor.
@browser.link(:id, /EditPaymentDetails/).click
Watir::Wait.until { @browser.text.include? "Payment options"}

data[ 'payments' ].each{ | pay |
    @browser.checkbox( :id => pay ).set
  }

@browser.span(:text, /Submit/).click

#We're coming full circle.
Watir::Wait.until { @browser.text.include? "Business details" }

#We need an IV of accurate trading hours, stat!
@browser.link(:id, /EditOpeningHours/).click
@browser.radio(:id, /SpecifiedHours_1/).set #Double-check errything
@browser.checkbox(:id, /DayRepeater/).clear #Why these fools set these automatically? Let's clear 'em.

if data['24hours'] == true
	@browser.radio( :id, /SpecifiedHours_0/).set
	@browser.text_field(:name, /HoursDescription/).set "We're open 24 Hours per day"
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

@browser.span(:text, /Submit/).click #That was a lot of code, let's get outta here!

#We're not in Kansas anymore, are we?
Watir::Wait.until { @browser.text.include? "Business details" }
@browser.span(:text, /Submit/).click
if @browser.text.include? "Do you want to continue?" then
	@browser.span(:text, /Submit/).click
end

#Not yet fully supported
#Add a service to flesh it out a bit, and bug out.
#@browser.link(:title, /Add your products and services (5+)/).click


#Looks like we could use some imagery.
#@browser.link(:title, /Add your business images/).click
#Watir::Wait.until { @browser.text.include? "Upload image" }
#if data['logo'].nil? then
#	puts("No Logo Found")
#else
#@browser.file_field(:name, /userfile/).set data['logo']
#
#	while @browser.div(:id, /uploadProcessBar/).size > 0
#		sleep(1)
#	end
#end
#count2 = 0
#if data['images'].nil? then
#	puts("No Images Found")
#else
#	until count2 > data['images'].length
#	@browser.file_field(:name, /userfile/).set data['images'][count2]
#		while @browser.div(:id, /uploadProcessBar/).size > 0
#		sleep(1)
#		end
#	count2 += 1
#	end
#end

#We're done here
puts("FinishListing Complete")
true