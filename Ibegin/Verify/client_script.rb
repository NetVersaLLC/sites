@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

def sign_in( data )

retries = 5

  begin
    @browser.goto( 'http://www.ibegin.com/account/login/' )
    @browser.text_field( :name, 'name' ).set data['email']
    @browser.text_field( :name, 'pw' ).set data['password']

    @browser.button( :value, /Login/i).click

    sleep 2
    Watir::Wait.until { @browser.link(:text => 'Logout').exists? }
    return true
  rescue
    if retries > 0
          puts "There was an error with the SignUp. Retrying in 5 seconds."
          retries -= 1
          sleep 5
          retry
      else
          puts "After 5 retries the payload could not sign in. Data available:"
          puts data
          puts "Data required:"
          puts "email,password"
          throw("Job failed during login. Verify the credintials are valid")
      end
  end
end

sign_in( data )
sleep(4)

@browser.goto("http://www.ibegin.com/business-center/")

@browser.link(:text => 'Claim Now').click
Watir::Wait.until { @browser.button(:value => 'Click to Call Your Phone & Receive Code').exists? }
retries = 5
begin
	@browser.button( :value => /Click to Call Your Phone & Receive Code/i).click
rescue
	if retries > 0
       puts "Button was not clicked/found. Retrying in 2 seconds."
       retries -= 1
       sleep 2
       retry
   else
       puts "After 5 retries the button could not be clicked."
   end
end


begin
	@browser.button( :value => /Click to Call Your Phone & Receive Code/i).click
	code = PhoneVerify.retrieve_code('Ibegin')

	@browser.text_field( :name => 'verification_code').set code
	@browser.button( :value => /Submit/).click

	sleep 2
	Watir::Wait.until(10) { @browser.text.include? "Congratulations! Your phone number has been verified."}	
true
rescue
	if retries > 0
		if @browser.text.include? "The code you entered did not match. Please re-try below"
       		puts "The code is incorrect."
		PhoneVerify.wrong_code('Ibegin')
       	end
       	puts("Phone Verify Failed, retrying in 2 seconds.")
       retries -= 1
       sleep 2
       retry
   else
       puts "After 5 retries the button could not be clicked."
   end
end








