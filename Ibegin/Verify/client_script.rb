# Developer Notes
# nil


# Browser code
@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

# Methods
def sign_in( data )
  @browser.goto( 'http://www.ibegin.com/account/login/' )
  @browser.text_field( :name, 'name' ).set data['email']
  @browser.text_field( :name, 'pw' ).set data['password']
  @browser.button( :value, /Login/i).click
  sleep(5)

  Watir::Wait.until { @browser.link(:text => 'Logout').exists? }
end

def do_the_thing(data)

  @browser.goto("http://www.ibegin.com/business-center/")
  sleep(5)
  @browser.link(:text => 'Claim Now').click
  sleep(5)
  Watir::Wait.until { @browser.button(:value => /Click to Call Your Phone/i).exists? }

  @browser.button( :value => /Click to Call Your Phone/i).click
  code = PhoneVerify.retrieve_code('Ibegin')

  @browser.text_field( :name => 'verification_code').set code
  @browser.button( :value => /Submit/).click
  sleep(10)
  Watir::Wait.until { @browser.text.include? "Congratulations! Your phone number has been verified."}	

end

@heap = JSON.parse( data['heap'] ) 

sign_in( data )
do_the_thing( data )

@heap['phone_verified'] = true
self.save_account("Ibegin", { :status => "Listing verified successfully!", "heap" => @heap.to_json })
self.start("Ibegin/UpdateListing")
self.success

