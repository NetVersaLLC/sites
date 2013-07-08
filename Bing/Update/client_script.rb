def update_business_portal_details( business )

   puts("Debug: Waiting for page to load")
   sleep(5)
  
  @browser.div( :class, 'businessCategory').a.click
  puts("Debug: Category Removed")



  @browser.checkboxes.each do |at|
    at.clear
  end
  puts("Debug: All checkboxes cleared")

  @browser.text_field( :title, 'Business Name' ).set business[ 'businessname' ]
  @browser.text_field( :title, 'Address Line 1' ).set business[ 'address_uno' ]
  @browser.text_field( :title, 'Address Line 2' ).set business[ 'address_dos' ]
  @browser.text_field( :title, 'City' ).set business[ 'city' ]
  @browser.text_field( :title, 'State' ).set business[ 'state_full' ]
  @browser.text_field( :title, 'Zip Code' ).set business[ 'zip' ]
  @browser.text_field( :title, 'Primary Phone Number' ).set business[ 'phone' ]
  @browser.text_field( :title, 'Email Address' ).set business[ 'hotmail' ]
  @browser.text_field( :title, 'Website' ).set business[ 'website' ]
  puts("Debug: Basic Data Updated Successfully")

  @browser.text_field( :title, 'Business Category' ).set business[ 'category' ]
  sleep(1)
  @browser.send_keys( :enter)
  @browser.button( :id, 'categoryAddButton').click
  puts("Debug: Category Updated Successfully")
end

def update_business_portal_additional_details( business )
  @browser.radio( :name => 'AdditionalBusinessInfo.OpHourDetail.OpHourType').set
  @browser.text_field( :name, 'AdditionalBusinessInfo.OpHourDetail.AdditionalInformation').set business[ 'hours' ]
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
   #@browser.file_field(:id, 'imageFiles1').set business[ 'logo' ]
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
puts "logo: " +logo.to_s
puts("4")
#   @browser.file_field(:id => 'imageFiles1').set logo
   sleep 5
   puts("5")
 #  @browser.button(:id => 'uploadPhoto1').click

  sleep 5
puts("6")
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
   Watir::Wait.until { @browser.h4( :text, 'Additional Business Details').exists? }

  @browser.h4( :text, 'Additional Business Details').click
  sleep(1)
  @browser.h4( :text, 'Online Presence').click
  sleep(1)
  @browser.h4( :text, 'Images and Videos').click
  sleep(1)
  @browser.h4( :text, 'Other Contact Information').click
  sleep(1)
  @browser.h4( :text, 'General Information').click
  puts("Debug: All Dropdown pages opened")
  sleep(1)


  update_business_portal_details( business )
  puts("Debug: Details update method complete")
  update_business_portal_additional_details( business )
  puts("Debug: Additional details update method complete")
  update_business_portal_online_presence( business )
  puts("Debug: Online presence details update method complete")
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
