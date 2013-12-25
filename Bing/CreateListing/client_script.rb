@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

#require 'gp_requires'
def add_new_listing( data )




  puts 'Add new listing'
  sleep 2
  @browser.button( :value, /Create new business/i ).when_present.click
retries = 3
begin
  sleep 2
  @browser.execute_script("hidePopUp()")
  sleep 2
  Watir::Wait.until { @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').exists? }
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').clear
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessName').set data['business']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine1').set data['address']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.AddressLine2').set data['address2']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').set data['city']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.City.CityName').send_keys :enter
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.State.StateName').set data['state_name']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessAddress.ZipCode').set data['zip']
  @browser.text_field(:name => 'BasicBusinessInfo.MainPhoneNumber.PhoneNumberField').set data['local_phone']
  @browser.text_field(:name => 'BasicBusinessInfo.BusinessEmailAddress').set data['hotmail']
  @browser.text_field(:name => 'BasicBusinessInfo.WebSite').set data['website']

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
  category.each{ |letter|
    sleep 0.1
    @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
  }
  puts "Category entered"
  sleep(5 - retries)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
  puts "Arrow down"
  sleep (5 - retries)
  @browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
  puts "Enter pressed"
  sleep(5 - retries)
  unless @browser.label(:for => /BasicBusinessInfo\.BusinessCategory\.Categories[autoValue.]\.CategoryName/).exists?
    puts "Trying something else.."
    @browser.text_field(:id => 'categoryInputTextBox').clear
    sleep 3
    category.each{ |letter|
      sleep 0.1
      @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
    }
    sleep 3
    puts "Hitting Enter..."
    @browser.send_keys :enter
    puts "Enter hit."
    sleep 5
    unless @browser.label(:for => /BasicBusinessInfo\.BusinessCategory\.Categories[autoValue.]\.CategoryName/).exists?
      puts "Trying YET ANOTHER something..."
      @browser.text_field(:id => 'categoryInputTextBox').clear
      sleep 3
      category.each{ |letter|
        sleep 0.1
        @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
      }
      sleep 3
      @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
      sleep 1
      @browser.text_field(:id => 'categoryInputTextBox').send_keys :arrow_down
      sleep 1
      @browser.text_field(:id => 'categoryInputTextBox').send_keys :enter
      sleep 3
      unless @browser.label(:for => /BasicBusinessInfo\.BusinessCategory\.Categories[autoValue.]\.CategoryName/).exists?
        puts "RRAAGGGHH!!"
        @browser.text_field(:id => 'categoryInputTextBox').clear
        sleep 3
        category.each{ |letter|
          sleep 0.2
          @browser.text_field(:id => 'categoryInputTextBox').send_keys letter
        }
        sleep 3
        @browser.text_field(:id => 'categoryInputTextBox').send_keys :tab
        sleep 3
      end
    end
  end
  @browser.button(:id => 'submitBusiness').click
  puts "Submitted"
  sleep(4 - retries)
  puts "Waiting for Verify Later"
  @browser.button(:value => 'Verify Later').when_present.click

  sleep(4 - retries)
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
    @browser.text_field(:name => 'City').when_present.set data['city'] + ", " + data['state']
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

def goto_listing( business )
  @browser.goto( 'http://www.bing.com/businessportal/' )
  @browser.link( :text , 'Sign In Here').click

  
  #Watir::Wait::until do
  #  @browser.div( :text, 'LISTINGS' ).exists?
  #end
  sleep(10)

  @browser.div( :class, 'LiveUI_Area_ClickOverlay' ).div( :text, business['businessname'] ).click
  
end


def solve_captcha2
  begin
  image = "#{ENV['USERPROFILE']}\\citation\\bing1_captcha.png"
  obj = @browser.img( :xpath, '//div/table/tbody/tr/td/img[1]' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

    return CAPTCHA.solve image, :manual
  rescue Exception => e
    puts(e.inspect)
  end
end

def enter_captcha
  captcharetries = 5
  capSolved = false
 until capSolved == true
    captcha_code = solve_captcha2 
    @browser.execute_script("
      function getRealId(partialid){
        var re= new RegExp(partialid,'g')
        var el = document.getElementsByTagName('*');
        for(var i=0;i<el.length;i++){
          if(el[i].id.match(re)){
            return el[i].id;
            break;
          }
        }
      }
      
      _d.getElementById(getRealId('wlspispSolutionElement')).value = '#{captcha_code}';

      ")
      sleep(5)

      @browser.execute_script('
        jQuery("#SignUpForm").submit()
      ')

      sleep 15

    if @browser.url =~ /https:\/\/account.live.com\/summarypage.aspx/i
      capSolved = true
    else
      captcharetries -= 1
    end
    if capSolved == true
      break
    end

  end

  if capSolved == true
    return true
  else
    throw "Captcha could not be solved"
  end
   

end


def solve_captcha3
  image = "#{ENV['USERPROFILE']}\\citation\\bing3_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="Popup_1||Search_Claim||Picture Password Verification"]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha3

  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha3 
    captcha_field = @browser.div(:class, 'LiveUI_Area_Picture_Password_Verification').text_field()
    captcha_field.set captcha_code

    @browser.div( :class, /LiveUI_Area_Continue_Button/ ).click
    
    sleep(2)
    if not @browser.text.include? "Characters do not match. Please try again."
      capSolved = true
    end
  count+=1
  end
  if capSolved == true
    true
  else
    throw("Captcha was not solved")
  end
end






sign_in_business( data )
search_for_business( data )

if not @businessfound == true

  add_new_listing( data )

  if @chained
    self.start("Bing/AdditionalDetails")
  end
  true
else
  puts("business found, attempting to claim")
  if @chained
    self.start("Bing/ClaimListing")
  end
  true
end
