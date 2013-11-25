@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

# Temporary methods from Shared.rb
def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\business_captcha.png"
  obj = @browser.image( :xpath, "/html/body/div[2]/div[2]/div/div/form/div/table/tbody/tr[2]/td/div/div[2]/table/tbody/tr[10]/td[2]/div/img" )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha( data )

  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha
    @browser.text_field( :id, 'captchaRes').set captcha_code
    @browser.link( :text, 'continue' ).click
    
    if @browser.div( :class, 'error').exists?
      errors = @browser.div( :class, 'error').text
      puts( errors )
    end

    if not @browser.text.include? "Please try again.  Entry did not match display."
      capSolve = true
    end
    
  count+=1  
  end

  if capSolve == true
    true
  else
    throw("Captcha was not solved")
  end
end
# End Temporary Methods from Shared.rb

url = 'http://www.superpages.com/'
@browser.goto(url)
@browser.link(:href,/business-listings/).click
@browser.text_field(:xpath, '/html/body/div[2]/div[2]/div/div/div/form/div/table/tbody/tr/td/table/tbody/tr[4]/td/input').set data[ 'phone' ]
@browser.span(:xpath, '/html/body/div[2]/div[2]/div/div/div/form/div/table/tbody/tr/td/table/tbody/tr[4]/td/span/a/span').click
if @browser.div(:id, 'matchHeader').text == 'Choose the most accurate listing for'	
		throw 'Business has already beeen registered'
else
	sleep(1)
	@browser.link(:text,'select').click
	@browser.link(:text,'next').click
	@browser.text_field( :name => 'listing.businessName' ).set data[ 'business' ]
#        @browser.text_field( :name => 'listing.contact' ).set data[ 'phone' ]
        @browser.text_field( :name => 'listing.address.address1' ).set data[ 'address' ]
        @browser.text_field( :name => 'listing.address.city' ).set data[ 'city' ]
        @browser.select_list( :name => 'listing.address.state' ).select data[ 'state' ]
        @browser.text_field( :name => 'listing.address.zip' ).set data[ 'zip' ]
        @browser.text_field( :name => 'bpinfo.websiteUrl' ).set data[ 'website' ]
	@browser.text_field(:name, 'searchtext').set data[ 'category' ]
	@browser.link(:xpath => '/html/body/div[2]/div[2]/div/div/form/div/table/tbody/tr/td/table/tbody/tr[7]/td/table/tbody/tr[3]/td/span/a').click
	sleep (3)
	@browser.span(:text => 'add >', :index => 0).when_present.click
	

	@browser.text_field( :name => 'customerProfile.firstname' ).set data[ 'first_name' ]
	@browser.text_field( :name => 'customerProfile.lastname' ).set data[ 'last_name' ]
	

        @browser.text_field( :name => 'customerProfile.email' ).set data[ 'email' ]
        @browser.text_field( :name => 'emailConfirmation' ).set data[ 'email' ]	
	
	enter_captcha(data)
	#captcha_text = solve_captcha()
	#@browser.text_field( :name => 'captchaRes' ).set captcha_text

	@browser.checkbox( :id, 'acceptterms').when_present.set
	@browser.link( :id => 'popup_ok' ).when_present.click

	
	if @browser.text.include? 'Confirm Your Email Address'
		puts( 'Registered, waiting email verification' )
		true
	end
end

