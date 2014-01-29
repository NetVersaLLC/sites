@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

def sign_in_business( data )

retries = 3
begin
    @browser.goto( 'https://www.bingplaces.com/' )

    @browser.button(:id => 'loginButton').click

    sleep 2
    @browser.link(:text => 'Login').when_present.click

    email_parts = {}
    email_parts = data[ 'hotmail' ].split( '.' )
    sleep 2
    Watir::Wait.until { @browser.input( :name, 'login' ).exists? }

    @browser.input( :name, 'login' ).send_keys email_parts[ 0 ]
    @browser.input( :name, 'login' ).send_keys :decimal
    @browser.input( :name, 'login' ).send_keys email_parts[ 1 ]
    # TODO: check that email entered correctly since other characters may play a trick
    @browser.text_field( :name, 'passwd' ).set data[ 'password' ]
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

captcha_types = { :sign_up, :add_listing }
def solve_captcha( type )

  if :sign_up == type then
    
    image = "#{ENV['USERPROFILE']}\\citation\\bing_signup_captcha.png"
    obj = @browser.image(:xpath, "//div/table/tbody/tr/td/img[1]")

  elsif :add_listing == type then

    image = "#{ENV['USERPROFILE']}\\citation\\bing_add_listing_captcha.png"
    obj = @browser.div( :class, 'LiveUI_Area_Picture_Password_Verification' ).image()

  else
    raise StandardError( 'Invalid capctha type specified' )
  end
  

  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual

end

def retryable(options = {}, &block)
  opts = { :tries => 1, :on => Exception }.merge(options)
  retry_exceptions, retries = opts[:on], opts[:tries]
  exceptLogger = []
  begin
    return yield
  rescue Exception => ex # FIXME # Currently catches everything... need to figure out 'rescue *retry_exceptions
    exceptLogger += [ex.inspect]
    sleep(3)
    retry if (retries -= 1) > 0
  raise StandardError.new("You maxed out on retries!  These error's came back: \n#{exceptLogger.join("\n")}")
  end
end

def watir_must( &block )
  retryable(:tries => 3, :on => [ Watir::Exception::UnknownObjectException, Timeout::Error ] ) do
    yield
  end
end

def search_for_business( data )
  retries = 3
  begin
  @browser.goto( 'http://www.bing.com/businessportal/' ) 
  sleep 2
  @browser.button( :value , 'Get Started' ).when_present.click
  sleep 2
  #@browser.link(:title => 'Add Your Business').when_present.click

  @businessfound = false


    
    sleep 2
    @browser.execute_script("hidePopUp()")
    #@browser.text_field(:name => 'PhoneNumber').when_present.set business['local_phone']
    @browser.text_field(:name => 'BusinessName').when_present.set data['business']
    @browser.text_field(:name => 'City').when_present.set data['city'] + ", " + data['state_short']
    @browser.execute_script("hidePopUp()")
    @browser.button(:value => 'Search').click
    @browser.execute_script("hidePopUp()")

    sleep 2
    Watir::Wait.until(10) { @browser.text.include? "Search Results" or @browser.text.include? "We found no businesses with the given information"}
   
    if @browser.text.include? "Search Results"
      @browser.links(:href => /http:\/\/www.bing.com\/local\/details.aspx/i).each do |item|
        if item.text =~ /#{data['business']}/i
          @businessfound = true
        end
      end 

    else
      @businessfound = false
    end
  

  rescue Watir::Wait::TimeoutError
      
    if retries > 0
      @browser.execute_script("hidePopUp()") #If the Script Error popup comes up this closes it.
      puts("Something went wrong, refreshing the page and trying again.")
      @browser.refresh
      retries -= 1
      retry
    end
  rescue Exception => e
    puts(e.inspect)
  end


  return @businessfound
end

def claim_it()
  retries = 3
  begin
    watir_must do @browser.button( :value , 'Select' ).click end
    Watir::Wait.until { @browser.text.include? "Tell us about your business" }
  rescue
    unless retries == 0
      retries -= 1
      retry
    end
  end
=begin
  count = 1
  begin
    captcha_text = solve_captcha( :add_listing )
    @browser.div( :class, 'LiveUI_Area_Picture_Password_Verification' ).text_field().set captcha_text
    @browser.div( :text , 'Continue' ).click
    count += 1
    if count > 10
      raise "Too many incorrect CAPTCHA solves"
    end
  end while @browser.html =~ /Characters did not match/

  #Watir::Wait::until do
  #  @browser.div( :text, 'Ok' ).exists? # or  :class, 'Dialog_TitleContainer'
  #end
  sleep(5)
  @browser.div( :text, /OK/i ).click
=end
  # Redirected to Business Portal - Details Page, so enter all the info as with new listing
end

def update_listing( data )




  puts 'Update listing'
retries = 3
begin
  sleep 2
  @browser.execute_script("hidePopUp()")
  sleep 2
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').when_present.clear
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').set data['business']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine1').set data['address']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine2').set data['address2']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').set data['city']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.State.StateName').set data['state_name']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.ZipCode').set data['zip']
  # Phone is updated in AdditionalDetails payload
  #@browser.text_field(:name => 'BasicBusinessInfo.MainPhoneNumber.PhoneNumberField').set data['local_phone']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessEmailAddress').set data['hotmail']
  @browser.text_field(:name => 'BasicBusinessInfo.WebSite').set data['website']

  preset_cats = false
  if @browser.element(:css , "a[onclick='removeBusinessCategory(this)']").exists?
    if @browser.elements(:css , "a[onclick='removeBusinessCategory(this)']").length > 1 then
      puts "Pre-existing categories detected, leaving them be."
      preset_cats = true
    else
      @browser.elements(:css , "a[onclick='removeBusinessCategory(this)']").each do |close|
        close.to_subtype.click
      end
    end
  end
  unless preset_cats == true
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
  end
  @browser.button(:id => 'submitBusiness').click
  puts "Submitted"
  sleep(4 - retries)
  puts "Waiting for Verify Later"
  @browser.element(:css => '.middlePane > div:nth-child(2) > input:nth-child(7)').when_present.click

  sleep(4 - retries)
  if @browser.text.include? "Bing Places encountered an internal error"
    raise 'Internal Error'
  end
  Watir::Wait.until { @browser.text.include? "All Businesses" }
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

  true

end

sign_in_business( data )
search_for_business( data )
claim_it()
update_listing( data )
if @chained
  self.start("Bing/AdditionalDetails")
end
