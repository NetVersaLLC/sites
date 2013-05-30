# Upload photo on google profile
def photo_upload_pop(photo)
	require 'rautomation'
	photo_upload_pop = RAutomation::Window.new :title => /File Upload/
	photo_upload_pop.text_field(:class => "Edit").set(photo)
	photo_upload_pop.button(:value => "&Open").click
end

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

def create_business( data )

	puts 'Business is not found - Creating business listing'
	
	@browser.goto "https://plus.google.com/pages/create"
	if @browser.div(:class => "W0 pBa").exist? && @browser.div(:class => "W0 pBa").visible?
          @browser.div(:class => "W0 pBa").click
        end
	@browser.div(:class => /AX kFa a-yb Vn a-f-e a-u-q-b/).when_present.click
	@browser.div(:text => "#{data['country']}").when_present.click
	@browser.text_field(:class, 'RBa Vn xBa c-cc LB-G ia-G-ia').when_present.set data['phone']
	@browser.div(:class => "a-f-e c-b c-b-M LC").when_present.click
	
	while not @browser.div(:class, "zX").exists? # No matches located
		sleep(3)
		puts 'Waiting on "No matches located" to appear.'
	end

	# Basic Information
	@browser.div(:class => "rta Si").click
	@browser.text_field(:xpath, "//input[contains(@label, 'Enter your business name')]").set data['business']
	@browser.text_field(:xpath, "//input[contains(@label, 'Enter your full business address')]").set data['address']
	@browser.text_field(:class=>'c-cc g9jP6 M3LyOb').set data['category']
	#~ @browser.text_field(:xpath, "//input[contains(@label, 'Address')]").send_keys :tab
	@browser.button(:name, 'ok').click
	@browser.text_field(:name => 'PlusPageName').when_present.set data['business']
	@browser.text_field(:name => 'Website').set data['website']
	@browser.div(:class => 'goog-inline-block goog-flat-menu-button-dropdown').click
	#~ @browser.div(:text, "#{data['business_category']}").click
	@browser.div(:text => 'Any Google+ user').click
	@browser.checkbox(:name => 'TermsOfService').set
	@browser.button(:value => 'Continue').click

        verify_phone(data) 
   	@browser.div(:text => 'Finish').click if @browser.div(:text => 'Finish').exist?
        @browser.div(:text => 'Edit business information').click if @browser.div(:text => 'Edit business information').exist?
        
        #Signin if it aski
        if @browser.text_field(:id => 'Passwd').exist?
          @browser.text_field(:id => 'Passwd').set data['pass']  
          @browser.button(:value, "Sign in").click
          @browser.wait()
	end
        sleep(5)
        @browser.div(:text=> 'Description').click
        @browser.frame(:class => 'Lj editable').body(:class => 'editable').send_keys data[ 'business_introduction' ]
        @browser.div(:text=> 'Save').click
        @browser.div(:text=> 'Done editing').click
	@browser.span(:text=> 'Verify').click if @browser.span(:text=> 'Verify').exist?

	verify_business()
end

def verify_business()
	if @browser.text.include?('Verify your business')
		puts "Sending request for verification"
		@browser.div(:class => 'a-f-e c-b c-b-M BNa').when_present.click
		@browser.wait()
		@browser.checkbox(:id, 'gwt-uid-50').when_present.set #terms
		@browser.link(:text,'Send postcard').click
               sleep(5)
	        if @browser.div(:id=> 'send-mailer-success-dialog-box').text.include?('You should receive a postcard with your PIN in about a week.')
		  puts "Initial business listing is successful"
	  	@browser.link(:text => 'OK').click
    	  	true
		end
	end
end

#Main Steps

retries = 3

begin
  login( data )
  search_for_business( data )
  if @browser.html.include?('No results')
    create_business( data )
  end

rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")
  retry
end
