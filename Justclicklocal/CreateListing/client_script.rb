sign_in( data )
sleep(5) # divs inside the dom load in late.


hours = data[ 'hours' ]

@browser.link( :text => 'Submit a New Listing').click

@browser.text_field( :id => 'name').set data[ 'business' ]
@browser.text_field( :id => 'address1').set data['address']
@browser.text_field( :id => 'address2').set data['address2']
@browser.text_field( :id => 'city').set data['city']
@browser.text_field( :id => 'phone').set data['phone']
@browser.select_list( :id => 'state').select data[ 'state' ]
@browser.text_field( :id => 'zip').set data['zip']
@browser.text_field( :id => 'url').set data['url']
@browser.text_field( :id => 'email').set data['email']
@browser.text_field( :id => 'fax').set data['fax']
@browser.text_field( :id => 'description').set data['description']
@browser.text_field( :id => 'products').set data['products']
@browser.text_field( :id => 'services').set data['services']
@browser.text_field( :id => 'brands').set data['brands']
@browser.text_field( :id => 'num_locations').set data['num_locations']
@browser.text_field( :id => 'num_employees').set data['num_employees']
@browser.text_field( :id => 'year_established').set data['year_established']

if data['24hours'] == true
	@browser.radio( :id => 'hours_1').click
else
	
	


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
    
		@browser.select_list( :id => "#{theday}_open").select open
			@browser.select_list( :id => "#{theday}_close").select close
	else
		@browser.select_list( :id => "#{theday}_open").select "Closed"
			@browser.select_list( :id => "#{theday}_close").select "Closed"
	end

end

	@browser.button( :name => 'NextButton').click

end

true


