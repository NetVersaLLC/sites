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

  Watir::Wait.until { @browser.link(:text => 'Logout').exists? }
rescue => e
  unless @retries == 0
    puts "Error caught in sign_in: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in sign_in could not be resolved. Error: #{e.inspect}"
  end
end

def do_the_thing(data)

@browser.goto("http://www.ibegin.com/business-center/")
@browser.link(:text => 'Claim Now').click
Watir::Wait.until { @browser.button(:value => 'Click to Call Your Phone & Receive Code').exists? }
retries = 5

@browser.button( :value => /Click to Call Your Phone & Receive Code/i).click
code = PhoneVerify.retrieve_code('Ibegin')

@browser.text_field( :name => 'verification_code').set code
@browser.button( :value => /Submit/).click

Watir::Wait.until { @browser.text.include? "Congratulations! Your phone number has been verified."}	

rescue => e
  unless @retries == 0
    puts "Error caught in do_the_thing: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in do_the_thing could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
@retries = 3
sign_in( data )
do_the_thing( data )
self.save_account("Ibegin", { :status => "Listing verified successfully!" })
self.success
