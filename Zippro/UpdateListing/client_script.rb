
sign_in(data)

@browser.link(:text => 'Edit Listing').when_present.click

@browser.link(:id => 'edit_business_add').when_present.click

@browser.text_field(:id => 'company').set data['business']
@browser.text_field(:id => 'street').set data['address']
@browser.text_field(:id => 'street2').set data['address2']
@browser.text_field(:id => 'city').set data['city']
@browser.text_field(:id => 'zip').set data['zip']
@browser.select_list(:id => 'state').select data['state_name']

@browser.button(:id => 'btnSubBusInfo').click
#End Updating Basic Info

#Begin Tab Selection (Some Javascript up in here, 'cause Ruby wouldn't work)
	@browser.execute_script("
      jQuery('li#tabt599829647').trigger('click')
    ")
#End Tab Selection

#Begin Updating Summary Description
	@browser.div( :id => 'brief_desc').a.hover
	sleep(1)
	@browser.div( :id => 'brief_desc').a.click

	@browser.text_field( :id => 'teaser').set data['description']
	@browser.button(:id => 'btnSubTeaser').click
#End Updating Summary Description

sleep(2)

#Begin Updating Hours of Operation (Incomplete)
	#@browser.div(:id => 'operational_hours').a.hover
	#sleep(1)
	#@browser.div(:id => 'operational_hours').a.click

	#@browser.radio(:id => 'specify').set
	#@browser.select(:id => 'time_open1_1').select 
#End Updating Hours of Operation


#Begin Updating Payment Options
	@browser.div( :id => 'payment_option').a.hover
	sleep(1)
	@browser.div( :id => 'payment_option').a.click
	
	#@browser.link(:xpath => '//*[@id="payment_option"]/a').click
	sleep(2)

	@browser.checkboxes.each do |jtd|
		jtd.clear
	end

	data['payments'].each do |pay|
		@browser.checkbox(:name => pay).click
	end
	
	@browser.button(:id => 'btnSubPayDesc').click
#End Updating Payment Options

#Begin Updating Tags
	@browser.div(:id => 'profile_tags').a.hover
	sleep(1)
	@browser.div(:id => 'profile_tags').a.click

	count = 1
	fth = data['tags'].gsub(" ","").split(",")
	puts(fth.each)
	while count < fth.length
		@browser.link(:id => 'add_another_tag').click
		sleep(1)
		count += 1
	end

	if @browser.text_field(:id => 'tag_0').exists?
	@browser.text_field(:id => 'tag_0').set fth[0]
	puts("Debug: First Tag Set")
	end
	sleep(1)
	if @browser.text_field(:id => 'tag_1').exists?
	@browser.text_field(:id => 'tag_1').set fth[1]
	puts("Debug: Second Tag Set") 
	end
	sleep(1)
	if @browser.text_field(:id => 'tag_2').exists?
	@browser.text_field(:id => 'tag_2').set fth[2]
	puts("Debug: Third Tag Set")
	end
	sleep(1)
	if @browser.text_field(:id => 'tag_3').exists?
	@browser.text_field(:id => 'tag_3').set fth[3]
	puts("Debug: Fourth Tag Set")
	end
	sleep(1)
	if @browser.text_field(:id => 'tag_4').exists? then
	@browser.text_field(:id => 'tag_4').set fth[4]
	puts("Debug: Fifth Tag Set")
	end
	sleep(1)
	@browser.button(:id => 'btnSubTags').click

#End Updating Tags
Watir::Wait.until {@browser.text.include? "Profile Tags have been saved."}

true








