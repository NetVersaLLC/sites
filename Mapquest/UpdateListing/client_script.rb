# Global Retry Count
@retries = 8

# Methods
def add_basic_info( data )
	@browser.div(:text, "Add or Claim Listing").when_present.click
	@browser.text_field(:id, "locationName").when_present.set data['business']
	@browser.text_field(:id, "locationAddress").set data['address']
	@browser.text_field(:id, "locationAddress2").set data['address2']
	@browser.text_field(:id, "locationCity").set data['city']
	@browser.select_list(:class, "wlabel-basicinfo-state").option(:value, "#{data['state']}").select
	@browser.text_field(:class, "wlabel-basicinfo-zip").set data['zip']
	@browser.text_field(:id, "locationPrimaryPhone").set data['phone']
	@browser.span(:class => "btn-var-inner", :text => "Continue").click
	@browser.span(:class => "btn-var-link btn-var-inner", :text => "Yes").when_present.click
	@browser.span(:class => "btn-var-inner", :text => "Add Business").when_present.click
	@browser.text_field(:id, "website").when_present.set data['website']
	@browser.text_field(:id, "description").set data['description']
rescue => e
  unless @retries == 0
    puts "Error caught while adding basic info: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding basic info could not be resolved. Error: #{e.inspect}"
  end
end

def set_category( data )
	# TODO
rescue => e
  unless @retries == 0
    puts "Error caught while setting category: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while setting category could not be resolved. Error: #{e.inspect}"
  end
end

def specify_business_hours( data )
	@browser.checkbox(:id, "hours-specify").set
	if data['24hours'] == true
		@browser.select_lists(:id, /hours-select/).each { |day| day.option(:value, "is24").select }
	else
		hours = data['hours']
		hours.each_with_index do |day, index|
			if hours[1][0] != "closed"
				open = hours[1][0]
				close = hours[1][1]
				@browser.text_field(:id, "hours-open-#{index}").set open
				@browser.text_field(:id, "hours-close-#{index}").set close
			else
				@browser.select_list(:id, "hours-select-#{index}").option(:value, "isClosed").select
			end
		end
	end
rescue => e
  unless @retries == 0
    puts "Error caught while adding hours of operation: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding hours of operation could not be resolved. Error: #{e.inspect}"
  end
end

def add_photos( data )
	if not self.logo.nil?
		@browser.span(:class => "jsonform-add-photo", :text => "Add photo")[1].click
		@browser.file_field(:id, "photo-caption").when_present.set self.logo
		@browser.span(:class => "btn-var-inner", :text => "Save").click
		@browser.div(:class => "jsonform-delete-photo", :text => "remove").wait_until_present
	elsif not self.images.nil?
		self.images.each_with_index do |image, index|
			@browser.span(:class => "jsonform-add-photo", :text => "Add photo")[1].click
			@browser.file_field(:id, "photo-caption").when_present.set image
			@browser.span(:class => "btn-var-inner", :text => "Save").click
			@browser.div(:class => "jsonform-delete-photo", :text => "remove")[index].wait_until_present
		end
	end
rescue => e
  unless @retries == 0
    puts "Error caught while adding photos: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding photos could not be resolved. Error: #{e.inspect}"
  end
end

def set_payment_methods( data )
	data['pay_methods'].each{ | pay_method |
    	@browser.checkbox( :id => pay_method ).set
  	}
  	@browser.span(:text, "Next Step").click
rescue => e
  unless @retries == 0
    puts "Error caught while setting payment methods: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while setting payment methods could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
sign_in( data )
add_basic_info( data )
set_category( data )
specify_business_hours( data )
set_payment_methods( data )