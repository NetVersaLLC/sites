@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

#require 'gp_requires'
def sign_in( business )

  @browser.goto( 'https://login.live.com/' )

  email_parts = {}
  email_parts = business[ 'hotmail' ].split( '.' )

  @browser.input( :name, 'login' ).send_keys email_parts[ 0 ]
  @browser.input( :name, 'login' ).send_keys :decimal
  @browser.input( :name, 'login' ).send_keys email_parts[ 1 ]
  # TODO: check that email entered correctly since other characters may play a trick
  @browser.text_field( :name, 'passwd' ).set business[ 'password' ]
  # @browser.checkbox( :name, 'KMSI' ).set
  @browser.button( :name, 'SI' ).click

end

def search_for_business( data )
  @browser.goto( 'http://www.bing.com/businessportal/' ) 
  sleep 2
  @browser.button( :value , 'Get Started' ).when_present.click
  sleep 2
  #@browser.link(:title => 'Add Your Business').when_present.click

  @browser.span(:id, 'loginText').click
  sleep 1
  unless @browser.link(:text, 'Sign Out').present?
    @browser.link(:text, 'Login').click
  end
end

def update_listing( data )
  @browser.link(:id, 'managePage').when_present.click
  @browser.link(:text, 'Edit').when_present.click
  puts 'Updating listing'
  sleep 2
  @browser.execute_script("hidePopUp()")
  sleep 2
  Watir::Wait.until { @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').exists? }
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').clear
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').set data['business']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine1').set data['address']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine2').set data['address2']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').set data['city']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').send_keys :tab
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.State.StateName').set data['state_name']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.ZipCode').set data['zip']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.MainPhoneNumber.PhoneNumberField').set data['local_phone']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessEmailAddress').set data['hotmail']
  sleep 1
  @browser.text_field(:name => 'BasicBusinessInfo.WebSite').set data['website']
  sleep 1

  if @browser.element(:css , "a[onclick='removeBusinessCategory(this)']").exists?
    @browser.elements(:css , "a[onclick='removeBusinessCategory(this)']").each do |close|
      close.to_subtype.click
    end
  end
  @browser.text_field(:id => 'categoryInputTextBox').clear
  category = Array.new
  data['category'].chomp.split("").each{ |letter|
    next if not letter =~ /[\w\d\s\!\@\#\$\%\^\&\*\(\)]/
    puts "Letter: " + letter
    category.push(letter)
  }
  sleep 3
  category.each{ |letter|
    sleep 0.1
    if letter =~ /\&/
      @browser.text_field(:id => 'categoryInputTextBox').send_keys [:shift, 7]
    else
      @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
    end
  }
  sleep 3
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :tab
  sleep 3
  ####
  unless @browser.img(:src, /CloseMark/).exists?
    puts "Trying something else.."
    @browser.text_field(:id => 'categoryInputTextBox').clear
    sleep 3
    category.each{ |letter|
    sleep 0.1
    if letter =~ /\&/
      @browser.text_field(:id => 'categoryInputTextBox').send_keys [:shift, 7]
    else
      @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
    end
  }
    sleep 3
    puts "Hitting Enter..."
    @browser.send_keys :enter
    puts "Enter hit."
    sleep 3
    unless @browser.img(:src, /CloseMark/).exists?
      puts "Trying YET ANOTHER something..."
      @browser.text_field(:id => 'categoryInputTextBox').clear
      sleep 3
      category.each{ |letter|
        sleep 0.1
        if letter =~ /\&/
            @browser.text_field(:id => 'categoryInputTextBox').send_keys [:shift, 7]
        else
            @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
        end
      }
      sleep 3
      @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
      sleep 1
      @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
      sleep 1
      @browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
      sleep 3
      unless @browser.img(:src, /CloseMark/).exists?
        puts "Come on, now..."
        @browser.text_field(:id => 'categoryInputTextBox').clear
        category.each{ |letter|
            sleep 0.1
            if letter =~ /\&/
                @browser.text_field(:id => 'categoryInputTextBox').send_keys [:shift, 7]
            else
                @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
            end
        }
        puts "Category entered"
        sleep(3)
        @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
        puts "Arrow down"
        sleep (2)
        @browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
        puts "Enter pressed"
        sleep(1)
        unless @browser.img(:src, /CloseMark/).exists?
          puts "RAAGGGHH!! *The payload rips off it's shirt and turns green*"
          @browser.text_field(:id => 'categoryInputTextBox').clear
          @browser.text_field(:id => 'categoryInputTextBox').set category.join.to_s
          sleep 3
          @browser.text_field(:id => 'categoryInputTextBox').send_keys :tab
          sleep 3
        end
      end
    end
  end
rescue Exception => e
  puts(e.inspect)
  if retries > 0
    puts("Something went wrong, trying again in 2 seconds..")
    sleep 2
    retries -= 1
    retry
  else
    throw e.inspect
  end
end

def additional_details( data )
  puts "Updating additional details"
  retries = 3
  begin
    @browser.h5(:text => 'Services, hours, photos & other details').click
    sleep 1 #Animation length
    #@browser.text_field(:name => 'AdditionalBusinessInfo.OpHourDetail.AdditionalInformation').set data['hours']
    @browser.text_field(:name => 'AdditionalBusinessInfo.Description').when_present.set data['description']
    @browser.text_field(:name => 'AdditionalBusinessInfo.YearEstablished').set data['founded']
  rescue Selenium::WebDriver::Error::ElementNotVisibleError
    if retries > 0
      retries -= 1
      retry
    else
      puts("Cound not add business hours, description, and year founded.")
    end
  end

  sleep 2
  retries = 3
  begin
    #@browser.h5(:text => 'Images and Videos').click
    unless self.logo.nil?
      @browser.file_field(:id, 'imageFiles1').set self.logo
      @browser.button(:id, 'uploadPhoto1').click
      sleep 2
      @browser.img(:src, /loading.gif/).wait_while_present
      @browser.img(:src, /https:\/\/bpprodstorage\.blob\.core\.windows\.net/).wait_until_present
    end

    unless self.images.length < 1
      for image in self.images
        @browser.file_field(:id, 'imageFiles2').set "#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images\\#{image}"
        @browser.button(:id, 'uploadPhoto2').click
        sleep 2
        Watir::Wait.until { @browser.button(:id, 'uploadPhoto2').enabled? }
      end
    end
  rescue => e
    if retries > 0
      retries -= 1
      retry
    else
      puts(e)
    end
  end

  retries = 3
  begin
    @browser.h5(:text => "Additional contact information").click
    sleep 2
    if data['mobile_appears']
      @browser.text_field(:name => 'AdditionalBusinessInfo.MobilePhoneNumber').set data['mobile']
    end
    @browser.text_field(:name => 'AdditionalBusinessInfo.TollFreeNumber').set data['tollfree']
    @browser.text_field(:name => 'AdditionalBusinessInfo.FaxNumber').set data['fax']
  rescue Selenium::WebDriver::Error::ElementNotVisibleError
    if retries > 0
      retries -= 1
      retry
    else
      puts("Could not add additional phone numbers")
    end
  end

  retries = 3
  begin
    #@browser.h5(:text => "General Information").click
    sleep 1

    data['payments'].each do |pay|
          puts "Payment: " + pay
      @browser.checkbox(:id => pay).clear
      @browser.checkbox(:id => pay).click
    end
  rescue Selenium::WebDriver::Error::ElementNotVisibleError
    if retries > 0
      retries -= 1
      retry
    else
      puts("Cound not add payment methods.")
    end
  end

  @browser.button(:id => 'submitBusiness').click

  Watir::Wait.until { @browser.text.include? "Validate your address" }
  puts "Validating..."
  @browser.element(:css, 'div.popUpAction:nth-child(4) > input:nth-child(1)').click

  sleep 2
  Watir::Wait.until { @browser.text.include? "All Businesses" }
end

sign_in( data )
search_for_business( data )
update_listing( data )
additional_details( data )
self.save_account("Bing", {:status => "Listing updated successfully!"})
true
