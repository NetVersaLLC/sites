# Upload photo on google profile
def photo_upload_pop(photo)
  require 'rautomation'
  photo_upload_pop = RAutomation::Window.new :title => /File Upload/
  photo_upload_pop.text_field(:class => "Edit").set(photo)
  photo_upload_pop.button(:value => "&Open").click
end

#Create new business
def create_business( data )
	
  puts 'Business is not found - Creating business listing'
  @browser.goto "https://plus.google.com/pages/create"
  
  if @browser.div(:class => "W0 pBa").exist? && @browser.div(:class => "W0 pBa").visible?
    @browser.div(:class => "W0 pBa").click
  end
  
  @browser.div(:class => 'AX kFa a-yb Vn a-f-e a-u-q-b').when_present.click
  @browser.div(:text => "#{data['country']}").when_present.click
  @browser.text_field(:class, 'RBa Vn xBa c-cc LB-G ia-G-ia').when_present.set data['phone']
  @browser.div(:class => "a-f-e c-b c-b-M LC").when_present.click

  while not @browser.div(:class, "zX").exists? # No matches located
    sleep(3)
    puts 'Waiting on "No matches located" to appear.'
  end

  # Basic Information
  @browser.div(:class => "rta Si").click
  @browser.text_field(:xpath, "//input[contains(@label, 'Enter your business name')]").when_present.set data['business']
  @browser.text_field(:xpath, "//input[contains(@label, 'Enter your full business address')]").set data['address']
  @browser.text_field(:class=>'c-cc g9jP6 M3LyOb').set data['category']
  @browser.button(:name, 'ok').click
  @browser.text_field(:name => 'PlusPageName').when_present.set data['business']
  @browser.text_field(:name => 'Website').set data['website']
  @browser.div(:class => 'goog-inline-block goog-flat-menu-button-dropdown').click
  @browser.div(:text => 'Any Google+ user').click
  @browser.checkbox(:name => 'TermsOfService').set
  @browser.button(:value => 'Continue').click

  verify_phone(data)
  
  @browser.div(:class => 'a-f-e c-b c-b-M Bl').when_present.click if @browser.div(:class => 'a-f-e c-b c-b-M Bl').exist?
        
  #Signin if it aski
  if @browser.text_field(:id => 'Passwd').exist?
    @browser.text_field(:id => 'Passwd').set data['pass']
    @browser.button(:value, "Sign in").click
    @browser.wait()
  end
  
  if @browser.wait_until {@browser.div(:class=> 'iph-dialog-dismiss-container').exist? }
	@browser.button(:value => 'Next').click until @browser.button(:value => 'Next').exist? == false
	@browser.button(:value => 'Done').click
  end

  #edit busienss information
  @browser.wait_until { @browser.div(:class => 'a-f-e c-b c-b-M FEjGyb lMPaj').exist?}
  @browser.div(:class => 'a-f-e c-b c-b-M FEjGyb lMPaj').click
  
  #Edit description
  @browser.div(:text=> 'Description').when_present.click
  @browser.frame(:class => 'Lj editable').body(:class => 'editable').when_present.send_keys data[ 'business_introduction' ]
  @browser.div(:text=> 'Save').when_present.click
  #~ @browser.div(:text=> 'Done editing').click
  
  #Verify Business
  if @browser.span(:text=> 'Verify').exist?
    @browser.span(:text=> 'Verify').click
  elsif @browser.div(:class => "c-v-x b-d b-d-nb Fg").exist? 
    @browser.div(:class => "c-v-x b-d b-d-nb Fg").click
  end
  verify_business()
end

#Verify phone
def verify_phone(data)
  if @browser.text_field(:id, 'signupidvinput').exist?
    @browser.text_field(:id, 'signupidvinput').when_present.set data[ 'phone' ]
    @browser.radio(:id,'signupidvmethod-voice').set
    @browser.button(:value,'Continue').click
    # fetch Phone verification code
    @code = PhoneVerify.ask_for_code
    if @browser.span(:class,'errormsg').exist?
      puts "#{@browser.span(:class,'errormsg').text}"
    end
    if @browser.text_field(:id,'verify-phone-input').exist?
      @browser.text_field(:id,'verify-phone-input').when_present.set @code
      @browser.button(:value,'Continue').click
        if @browser.span(:class,'errormsg').exist?
        puts "#{@browser.span(:class,'errormsg').text}"
        end
    end
  end
end

#Main Steps
begin
  login( data )
  search_for_business( data )
  if @browser.html.include?('No results')
    puts "Create a new busienss"
    create_business( data )
  end

rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")
  retry

rescue Exception => e
    puts "Caught a #{e.message}"
end
