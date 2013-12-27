@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

def sign_in( data )

  @browser.goto( 'https://login.live.com/' )

  email_parts = {}
  email_parts = data[ 'hotmail' ].split( '.' )

  @browser.input( :name, 'login' ).send_keys email_parts[ 0 ]
  @browser.input( :name, 'login' ).send_keys :decimal
  @browser.input( :name, 'login' ).send_keys email_parts[ 1 ]
  # TODO: check that email entered correctly since other characters may play a trick
  @browser.text_field( :name, 'passwd' ).set data[ 'password' ]
  # @browser.checkbox( :name, 'KMSI' ).set
  @browser.button( :name, 'SI' ).click

end

sign_in( data )
if @browser.url =~ /mail\.live\.com\/default\.aspx/ 
    # Continue
else
    @browser.goto('mail.live.com')
    sleep 5
end
options = @browser.url + "#!/mail/options.aspx"
@browser.goto(options)

@opt_frame = @browser.frame( :id, 'appFrame')
@opt_frame.link( :text, /Rules for sorting new messages/i).when_present.click
@opt_frame.button( :id, 'NewFilter').when_present.click

@opt_frame.select_list( :id, 'VerbDropDown').select "contains"
@opt_frame.text_field( :id, 'MatchString').set "@"
@opt_frame.button( :value, /Save/).click

puts "Rule set"

if @chained
	self.start("Bing/CreateListing")
end

true
