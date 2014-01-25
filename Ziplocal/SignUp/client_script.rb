@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def add_category( data )
	#Now to add categories. At least 1 category is required.
	@browser.button( :id, 'listingForm:addTest2' ).fire_event("onClick")

	#wait until category text field loads
	Watir::Wait.until { @browser.text_field( :id, 'listingForm:newSic1').present? }

	#focus the field so we can get the javascript happy
	@browser.text_field( :id, 'listingForm:newSic1').focus
	@browser.text_field( :id, 'listingForm:newSic1').set data[ 'categoryKeyword' ]

	@browser.button( :value, 'Add new').when_present.click
	sleep(3)	
	until @browser.select_list(:id, 'listingForm:sicList').option(:text, "#{data['categoryKeyword']}").exists?
		@browser.text_field( :id, 'listingForm:newSic1').focus
		@browser.text_field( :id, 'listingForm:newSic1').set data[ 'categoryKeyword' ]
		@browser.button( :value, 'Add new').click # Clicking will continue until morale improves
		if @retries < 1
			self.failure("Could not set category.")
			return false
		else
			puts "Category didn't set. Retrying..."
			@retries -= 1
		end
	end
	return true
end

def add_business( data )
#adds the business, begins by clicking the "add this number" link
	if @retries < 3
		@browser.refresh
	else
		@browser.link( :text, 'add this number' ).when_present.click
	end
	#fill out the form with client data
	@browser.text_field( :id, 'listingForm:disp').when_present.set data[ 'business' ]
	@browser.text_field( :id, 'listingForm:StrAdr').set data[ 'streetnumber' ]
	@browser.text_field( :id, 'listingForm:city').set data[ 'citystate' ]
	@browser.text_field( :id, 'listingForm:zip').set data[ 'zip' ]
	@browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
	@browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
	@browser.text_field( :id, 'listingForm:_id154').set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
	@browser.text_field( :id, 'listingForm:_id159').set data[ 'email' ]
	@browser.radio( :value, 'O').set
	@browser.text_field(:id, "listingForm:_id157").set data['prefix'] #Good to add the prefix lately.

	if add_category(data) == false
		break
	end

	sleep(3)
	@browser.link( :text, 'Save').click

	if @browser.text.include? "We apologize but your order can not be submitted"
		self.failure("Only one submission permitted per day.")
	else
		Watir::Wait.until { @browser.text.include? "Thank you for updating our directory." }
		puts "Business added successfully."
		self.success
	end
rescue => e
  unless @retries == 0
    puts "Error caught in add_business: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    self.failure("Error in add_business could not be resolved. Error: #{e.inspect}")
  end
end

def main( data )
#this method runs the show
	@browser.goto('http://www.ziplocal.com/olc/lookup.faces')

	#enter the phone number
	@browser.text_field( :id, 'lookupForm:tel').when_present.set data[ 'phone' ]
	@browser.link( :id, 'lookupForm:submit').click
	
	if @browser.text.include? 'We found the following'
		puts ("Phone number already associated.")
		@browser.div(:id, "content_container_solid").links.each{ |result|
			next if result.text.nil?
			puts "Result: #{result.text}"
			rtext = result.text.to_s
			rtext = rtext.strip
			rtext = rtext.downcase
			rtext = rtext.gsub(" ", "")
			if rtext.include? data[ 'business' ].downcase.gsub(" ","")
				listing_url = result
				self.save_account("Ziplocal",{:listing_url => listing_url.href })
				self.success("Pre-existing business link grabbed successfully.")
				break
			else
				self.failure("Phone number associated with a different business.")
			end
		}
	else
		add_business(data)
	end
end
@retries = 3
main( data )
