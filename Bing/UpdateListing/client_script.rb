@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

def sign_in_business( business )

retries = 3
begin
    @browser.goto( 'https://www.bingplaces.com/' )

    @browser.button(:id => 'loginButton').click

    sleep 2
    @browser.link(:text => 'Login').when_present.click

    email_parts = {}
    email_parts = business[ 'hotmail' ].split( '.' )
    sleep 2
    Watir::Wait.until { @browser.input( :name, 'login' ).exists? }

    @browser.input( :name, 'login' ).send_keys email_parts[ 0 ]
    @browser.input( :name, 'login' ).send_keys :decimal
    @browser.input( :name, 'login' ).send_keys email_parts[ 1 ]
    # TODO: check that email entered correctly since other characters may play a trick
    @browser.text_field( :name, 'passwd' ).set business[ 'password' ]
    # @browser.checkbox( :name, 'KMSI' ).set
    @browser.button( :name, 'SI' ).click

    sleep 2
    Watir::Wait.until {@browser.button(:id => 'loginButton').exists?}

    if @browser.button(:id => 'loginButton').text =~ /Sign in/i
      throw "Sign-in failed"
    end


  rescue Exception => e
    if retries > 0
      puts e.inspect
      retries -= 1
      retry
    else
      throw "Sign in was not able to complete. "
    end
  end



end

def update_business_portal_details( business )

   puts("Debug: Waiting for page to load")
   sleep(5)
  
  if @browser.element(:css , "a[onclick='removeBusinessCategory(this)']").exists?
  	@browser.execute_script("hidePopUp()")
  	sleep(2)
    @browser.elements(:css , "a[onclick='removeBusinessCategory(this)']").each do |close|
      close.to_subtype.click
    end
    puts("Debug: Categories Removed")
  end



  @browser.checkboxes.each do |at|
    at.clear
  end
  puts("Debug: All checkboxes cleared")

  @browser.execute_script("hidePopUp()")
  sleep(2)
  if @browser.text.include? "Browse Categories" then
  	@browser.button(:value, 'Cancel').click
  	sleep(2)
  end
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').set business[ 'businessname' ]
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine1').set business[ 'address_uno' ]
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine2').set business[ 'address_dos' ]
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').set business[ 'city' ]
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.State.StateName').set business[ 'state_full' ]
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.ZipCode').set business[ 'zip' ]
  @browser.text_field(:name => 'BasicBusinessInfo.MainPhoneNumber.PhoneNumberField').set business[ 'phone' ]
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessEmailAddress').set business[ 'hotmail' ]
  @browser.text_field(:name => 'BasicBusinessInfo.WebSite').set business[ 'website' ]
  puts("Debug: Basic Data Updated Successfully")

  @browser.text_field(:id => 'categoryInputTextBox').set business[ 'category' ]
  sleep(2)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
  sleep(1)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
  sleep(2)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
  #@browser.button( :id, 'categoryAddButton').click
  puts("Debug: Category Updated Successfully")
	if @browser.text.include? "Please enter at least one category." then
		@browser.text_field(:id => 'categoryInputTextBox').set business[ 'category' ]
  		sleep(2)
  		@browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
  		sleep(2)
  		@browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
  		sleep(2)
  		@browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
  		#@browser.button( :id, 'categoryAddButton').click
	end
end

def update_business_portal_additional_details( business )
	if business[ '24hours' ] == true then
		@browser.radio( :name => 'AdditionalBusinessInfo.OpHourDetail.OpHourType', :value => 'Open24Hours').set
	else
  	@browser.radio( :name => 'AdditionalBusinessInfo.OpHourDetail.OpHourType').set
  	@browser.text_field( :name, 'AdditionalBusinessInfo.OpHourDetail.AdditionalInformation').set business[ 'hours' ]
  	end
  	puts("Debug: Hours Set")
  	@browser.text_field( :name, 'AdditionalBusinessInfo.Description').set business[ 'description' ]
  	@browser.text_field( :name, 'AdditionalBusinessInfo.YearEstablished').set business[ 'year_established' ]
  	@browser.text_field( :name, 'AdditionalBusinessInfo.OpHourDetail.AdditionalInformation').set business[ 'brands ']
  puts("Debug: Additional Data Updated Successfully")
end

def update_business_portal_online_presence( business )
  if @browser.text_field(:name, 'AdditionalBusinessInfo.FacebookWebsite').visible?
    @browser.text_field(:name, 'AdditionalBusinessInfo.FacebookWebsite').set business[ 'facebook' ]
    @browser.text_field(:name,'AdditionalBusinessInfo.TwitterWebsite').set business[ 'twitter' ]
  end
  puts("Debug: Online Presence Updated Successfully")
end

def update_business_portal_images_and_videos ( business )
   #@browser.file_field(:id, 'imageFiles1').set self.logo
   puts("Debug: Logo Path Set")
   #@browser.button(:id, 'uploadPhoto1').click
puts("1")
  @browser.links(:text => 'X').each do |alink|      
      puts("2")
        alink.click if alink.visible?
        sleep 1

  end

puts("3")

#  logo = self.logo
#puts "logo: " +logo.to_s
puts("4")
#   @browser.file_field(:id => 'imageFiles1').set logo
   sleep 5
   puts("5")
 #  @browser.button(:id => 'uploadPhoto1').click

  sleep 5
puts("6")
=begin
if not self.images.exists? or self.images.nil? then
  images = self.images
  puts images.to_s
  puts("7")
  while @browser.img(:xpath => '//*[@id="imageContainer1"]/span/div/img').attribute_value("src") == "https://www.bingplaces.com/Images/loading.gif" do sleep 1 end 
puts("8")
   pbm = 0
   if images.length > 0
      puts(images[pbm]['file_name'])
        while pbm < images.length
          @browser.file_field(:id, 'imageFiles2').set images[pbm]['file_name']
          sleep 4
          #@browser.button(:id => 'uploadPhoto2').click
puts("9")
          sleep 2
          otherpbm = pbm + 1
          @browser.execute_script("startImageUpload(2)")
          puts("Before wait")
          while @browser.img(:xpath => "//*[@id='imageContainer2']/span/div[#{otherpbm}]/img").attribute_value("src") == "https://www.bingplaces.com/Images/loading.gif" do sleep 1 end 
            puts("Right after wait")
            sleep 5
          pbm += 1
        end
  end
end  
=end
end

def update_business_portal_other_contact_information( business )
  @browser.text_field(:name, 'AdditionalBusinessInfo.MobilePhoneNumber').set business[ 'mobile' ]
  @browser.text_field(:name, 'AdditionalBusinessInfo.TollFreeNumber').set business[ 'toll_free_number' ]
  @browser.text_field(:name, 'AdditionalBusinessInfo.FaxNumber').set business[ 'fax_number' ]
  puts("Debug: Other Contact Information Updated Successfully")
end

def update_business_portal_general_information( business )
  business[ 'payments' ].each do |pay|
  @browser.checkbox(:id, pay).set
  end
  @browser.text_field(:name, 'AdditionalBusinessInfo.LanguageSpoken').set business[ 'languages' ]
end

#def enter_business_portal_mobile()
  #Watir::Wait::until do
  #  @browser.div( :text, 'MOBILE SITE' ).exists?
  #end
#sleep(5)
  #@browser.div( :class, 'LiveUI_Area_FreeMobileSite' ).div( :class, 'LiveUI_Field_Flag' ).click
  #@browser.div( :class, 'LiveUI_Area_CreateQRCode' ).div( :class, 'LiveUI_Field_Flag' ).click
#
 # @browser.div( :text, 'Next' ).click
#end

def editmode()
  @browser.div( :id, 'businessList1').a( :text, 'Edit').click
end


def update( business )
  sign_in_business( business )
  puts("Debug: Signed in")
  editmode()
  puts("Debug: Edit Mode Activated")
   sleep 2
   Watir::Wait.until { @browser.h5( :text, 'Additional Business Details').exists? }

  @browser.h5( :text, 'Additional Business Details').click
  sleep(1)
  #@browser.h5( :text, 'Online Presence').click
  #sleep(1)
  @browser.h5( :text, 'Images and Videos').click
  sleep(1)
  @browser.h5( :text, 'Other Contact Information').click
  sleep(1)
  @browser.h5( :text, 'General Information').click
  puts("Debug: All Dropdown pages opened")
  sleep(1)


  update_business_portal_details( business )
  puts("Debug: Details update method complete")
  update_business_portal_additional_details( business )
  puts("Debug: Additional details update method complete")
  #update_business_portal_online_presence( business )
  #puts("Debug: Online presence details update method complete")
  update_business_portal_images_and_videos ( business )
  puts("Debug: Images and videos update method complete")
  update_business_portal_other_contact_information( business )
  puts("Debug: Other contact information update method complete")
  update_business_portal_general_information( business )
  puts("Debug: General information update method complete")
  @browser.button(:id, 'submitBusiness').click
  puts("Debug: Overall Update Successful!")
end

update( data )

puts("Debug: Mission Accomplished")
true
