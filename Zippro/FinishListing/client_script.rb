
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

Watir::Wait.until { @browser.text.include? "Business Info has been saved."}

#Begin Updating Logo
if not data['logo'] == nil then
	imagetrue = true
	@browser.div( :id => 'profile_logo_thumb').hover
	sleep(2)
	@browser.div( :id => 'profile_logo_thumb').a( :id => 'edit_profile_logo').click
	@browser.file_field( :id => 'logo_browse_field').set data['logo']
	sleep(15)
	@browser.button( :id => 'btnLogoSave').click
else
	puts("No Logo Found")
end
#End Updating Logo

if imagetrue == true then
Watir::Wait.until { @browser.text.include? 'Image has been uploaded successfully.' }
else
	sleep(2)
end

#Begin Updating Website & Email
	@browser.div(:id => 'bc_wrapp').a(:id => 'edit_business_contact').click
	@browser.text_field(:id => 'email').set data['email']
	@browser.text_field(:id => 'website').set data['website']
	@browser.button( :id => 'btnSubContInfo').click
#End Updating Website & Email

#Begin Updating Summary Description
	@browser.div( :id => 'brief_desc').a.hover
	sleep(1)
	@browser.div( :id => 'brief_desc').a.click

	@browser.text_field( :id => 'teaser').set data['description']
	@browser.button(:id => 'btnSubTeaser').click
#End Updating Summary Description

sleep(2)

#Begin Updating Hours of Operation (Incomplete)

	@browser.div(:id => 'operational_hours').a.hover
	sleep(1)
	@browser.div(:id => 'operational_hours').a.click

	@browser.radio(:id => 'specify').set
	  hours = data['hours']

  hours.each_pair do | bmo, finn |

    daay = bmo[0..2]
    if finn.to_s == "closed"

    	if daay == 'mon' then
    		@browser.checkbox( :id => 'hr_close_1').set
    	end

    	if daay == 'tue' then
    		@browser.checkbox( :id => 'hr_close_2').set
    	end

    	if daay == 'wed' then
    		@browser.checkbox( :id => 'hr_close_3').set
    	end

    	if daay == 'thu' then
    		@browser.checkbox( :id => 'hr_close_4').set
    	end

    	if daay == 'fri' then
    		@browser.checkbox( :id => 'hr_close_5').set
    	end

    	if daay == 'sat' then
    		@browser.checkbox( :id => 'hr_close_6').set
    	end

    	if daay == 'sun' then
    		@browser.checkbox( :id => 'hr_close_7').set
    	end

    else

        openHour = finn['open']
        closeHour = finn['close']
        if openHour[0,1] == "0"
          openHour = openHour[1..-1].upcase.gsub(".","")
        end
        if closeHour[0,1] == "0"
          closeHour = closeHour[1..-1].upcase.gsub(".","")
        end     

        if daay == 'mon' then
        	@browser.select_list(:id => 'time_open1_1').select openHour
        	@browser.select_list(:id => 'time_close1_1').select closeHour
        end

        if daay == 'tue' then
        	@browser.select_list(:id => 'time_open1_2').select openHour
        	@browser.select_list(:id => 'time_close1_2').select closeHour
        end

        if daay == 'wed' then
        	@browser.select_list(:id => 'time_open1_3').select openHour
        	@browser.select_list(:id => 'time_close1_3').select closeHour
        end

        if daay == 'thu' then
        	@browser.select_list(:id => 'time_open1_4').select openHour
        	@browser.select_list(:id => 'time_close1_4').select closeHour
        end

        if daay == 'fri' then
        	@browser.select_list(:id => 'time_open1_5').select openHour
        	@browser.select_list(:id => 'time_close1_5').select closeHour
        end

        if daay == 'sat' then
        	@browser.select_list(:id => 'time_open1_6').select openHour
        	@browser.select_list(:id => 'time_close1_6').select closeHour
        end

        if daay == 'sun' then
        	@browser.select_list(:id => 'time_open1_7').select openHour
        	@browser.select_list(:id => 'time_close1_7').select closeHour
        end


    end
  end

  @browser.button( :id => 'btnSubHours').click
#End Updating Hours of Operation

Watir::Wait.until { @browser.text.include? 'Hours of Operation have been saved.' }

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
	if @browser.text_field(:id => 'tag_#{fth.length}').exists? then
		break
	else
		while count < fth.length
			@browser.link(:id => 'add_another_tag').click
			sleep(1)
			count += 1
		end
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


puts("Success!")
true