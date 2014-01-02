@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}

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

sign_in_business(data)

sleep 2
@browser.link(:text => /Enter PIN/i).when_present.click

sleep 2
code = "1234"#PhoneVerify.retrieve_code("Bing")
@browser.text_field(:id => 'Pin').when_present.set code

sleep 2
@browser.execute_script("ValidateAndPerformAjaxCall('SubmitVerificationPIN', '#enterPinForm')")

sleep 10
true