#require 'gp_requires'

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


def search_for_business( business )
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
    @browser.text_field(:name => 'PhoneNumber').when_present.set business['local_phone']
    @browser.execute_script("hidePopUp()")
    @browser.button(:value => 'Search').click
    @browser.execute_script("hidePopUp()")

    sleep 2
    Watir::Wait.until(10) { @browser.text.include? "Search Results" or @browser.text.include? "We found no businesses with the given information"}
   
    if @browser.text.include? "Search Results"
      @browser.link(:href => /http:\/\/www.bing.com\/local\/details.aspx/i).each do |item|
        if item.text =~ /#{business['business']}/i
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



@browser = Watir::Browser.new
at_exit do
  @browser.close
end

sign_in( data )
@browser.goto( 'mail.live.com/mail/options.aspx' )

30.times { break if (begin @browser.link(:id => "iShowSkip").exists? or @browser.frame( :id, 'appFrame').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

if @browser.link(:id => "iShowSkip").exists?
	@browser.link(:id => "iShowSkip").click

	30.times { break if (begin @browser.text.include? "Account summary" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
	
	@browser.goto( 'mail.live.com/mail/options.aspx' )	

	30.times { break if (begin @browser.frame( :id, 'appFrame').exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
	
end

@opt_frame = @browser.frame( :id, 'appFrame')
30.times { break if (begin @opt_frame.link( :text, /Rules for sorting new messages/i).present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
@opt_frame.link( :text, /Rules for sorting new messages/i).when_present.click
30.times { break if (begin @opt_frame.button( :id, 'NewFilter').present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
@opt_frame.button( :id, 'NewFilter').when_present.click

@opt_frame.select_list( :id, 'VerbDropDown').select "contains"
@opt_frame.text_field( :id, 'MatchString').set "@"
@opt_frame.button( :value, /Save/).click

if @chained
		self.start("Bing/CreateListing")
end

true
