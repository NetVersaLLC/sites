@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def solve_captcha2
  image = ["#{ENV['USERPROFILE']}",'\citation\disc_captcha.png'].join
  obj = @browser.img( :id => "recaptcha_challenge_image")
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  sleep(3)
  return CAPTCHA.solve image, :manual
end

def enter_captcha
  3.times do
    captcha_code = solve_captcha2	
    @browser.text_field(:id => "recaptcha_response_field").set captcha_code
    @browser.input(:value => "Submit").click

    Watir::Wait.until do 
      @browser.form(:text => /response was incorrect/).exist? || 
      @browser.h1(:text => "Select Your Listing").exist?
    end 
    return true if @browser.h1(:text => "Select Your Listing").exist?
  end 
  return false
end

# End Temporary Methods from Shared.rb
def add_listing(data)
	@browser.text_field(:name => 'ListContact').when_present.set data[ 'full_name' ]
	@browser.text_field(:name => 'ReqEmail').when_present.set data[ 'email' ]
	@browser.text_field(:name => 'ListOrgName').set data[ 'business' ]
	@browser.text_field(:name => 'ListAddr1').set data[ 'address' ]
	@browser.text_field(:name => 'ListCity').set data[ 'city' ]
	@browser.text_field(:name => 'ListState').set data[ 'state' ]
	@browser.text_field(:name => 'ListZip').set data[ 'zip' ]
	@browser.text_field(:name => 'ListPhone').set data[ 'phone' ]
	@browser.text_field(:name => 'ListWebAddress').set data[ 'website' ]
	@browser.text_field(:name => 'ListStatement').set data[ 'business_description' ]

	#Enter Decrypted captcha string here
	return false unless enter_captcha

	@browser.link(:href => 'thankyou.php').click
        @browser.p(:text => /submission was successful/).wait_until_present
	true
end

url = 'http://www.discoverourtown.com/add/'
@browser.goto(url)

if add_listing(data)
  self.save_account("Discoverourtown", {:email => data[ 'email' ], :status => "Listing created. Waiting for approval"})
  self.success
else 
  self.failure("Captcha failed")
end 
