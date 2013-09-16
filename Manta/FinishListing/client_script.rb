# Global Retry Count, affects all rescues
@retries = 8

# Methods
def sign_in( data )
	@browser.goto("https://www.manta.com/member/login")
	@browser.text_field(:id, "email").when_present.set data['email']
	@browser.text_field(:id, "password").set data['password']
	@browser.text_field(:id, "password").send_keys :enter
	Watir::Wait.until { @browser.text.include? "Post an Update" }
rescue => e
  unless @retries == 0
    puts "Error during sign in: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught during sign in could not be resolved. Error: #{e.inspect}"
  end
end

def add_logo()
	@browser.link(:text, "Your Business").hover
	@browser.link(:text, "Edit Company Info").when_present.click
	if not self.logo.nil?
		@browser.div(:id, "o-logo").when_present.click
		@browser.file_field(:id, "uploaded_file").set self.logo
		sleep 2
		until @browser.img(:src, /loading_gears.gif/).exists? == false
			sleep 1
		end
		@browser.span(:text, "Save").click
		@browser.span(:text, "No, Thanks").when_present.click
	end
rescue => e
  unless @retries == 0
    puts "Error while adding logo: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding logo could not be resolved. Error: #{e.inspect}"
  end
end

def add_description( data )
	@browser.div(:id, "o-description").click
	@browser.textarea(:id, "claimed.short_description").when_present.set data['short_desc']
	@browser.textarea(:id, "claimed.detailed_description").set data['description']
	@browser.span(:text, "Save").click
	sleep 2
	until @browser.div(:id, "dialog-claim-edit-saving").exists? == false
		sleep 1
	end
rescue => e
  unless @retries == 0
    puts "Error adding business description: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error adding business description could not be resolved. Error: #{e.inspect}"
  end
end

def add_contact_information( data )
	@browser.div(:id, "o-morecontact").when_present.click
	@browser.text_field(:name, "claimed.websites.0.site").set data['website']
	# TODO - Public Email not yet available @browser.text_field(:name, "claimed.emails.0.address").set
	@browser.span(:text, "Save").click
	sleep 2
	until @browser.div(:id, "dialog-claim-edit-saving").exists? == false
		sleep 1
	end
rescue => e
  unless @retries == 0
    puts "Error while adding contact information: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding contact information could not be resolved. Error: #{e.inspect}"
  end
end

def add_hours( data )
	@browser.div(:id, "o-hours").when_present.click
	Watir::Wait.until { @browser.textarea(:id, "claimed.office_hours_description").exists? }
	hours = data['hours']
  	if data['24hour'] == true
  		@browser.textarea(:id, "claimed.office_hours_description").set "Open 24/7"
    	@browser.selectlist(:id, "monday_start").set "12:00 AM"
    	@browser.selectlist(:id, "monday_end").set "12:00 AM"
    	@browser.div(:class, "apply-to-all").click
  	else
    	hours.each_with_index { |day, index|
    	if day[1][0] != "closed"
    	    open = day[1][0].upcase
    	    close = day[1][1].upcase
    	    theday = day[1]
    	    @browser.selectlist(:name, "#{theday}_start").select open
    	    @browser.selectlist(:name, "#{theday}_end").select close
    	else
    		@browser.selectlist(:id, "#{theday}_start").select "CLOSED"
    		@browser.selectlist(:id, "#{theday}_end").select "CLOSED"
    	end
    	}
  	end
  	@browser.span(:text, "Save").click
    sleep 2
	until @browser.div(:id, "dialog-claim-edit-saving").exists? == false
		sleep 1
	end
rescue => e
  unless @retries == 0
    puts "Error while adding hours of operation: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding hours of operation could not be resolved. Error: #{e.inspect}"
  end
end

def add_categories( data )
	# TODO - Finish once categories have been scraped
rescue => e
  unless @retries == 0
    puts "Error adding categories: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding categories could not be resolved. Error: #{e.inspect}"
  end
end

def add_miscellaneous_information( data )
	@browser.div(:id, "o-information").click
	@browser.text_field(:id, "year_started").when_present.set data['year_founded']
	@browser.span(:text, "Save").click
	sleep 2
	until @browser.div(:id, "dialog-claim-edit-saving").exists? == false
		sleep 1
	end
rescue => e
  unless @retries == 0
    puts "Error caught while adding misc information: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding misc information could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
sign_in( data )
add_logo()
add_description( data )
add_contact_information( data )
add_hours( data )
add_categories( data )
add_miscellaneous_information( data )
true