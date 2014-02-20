@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def sign_in(data)
  @browser.goto("https://www.yellowbot.com/signin")
  @browser.text_field( :name => 'login').set data['email']
  @browser.text_field( :name => 'password').set data['password']
  @browser.button( :name => 'subbtn').click
end

@browser.goto( "http://www.yellowbot.com/" )
@browser.text_field( :id => 'search-field' ).set data[ 'phone' ]
@browser.button( :value => 'Find my business' ).click #, :type => 'submit'

@browser.link( :text, "#{data[ 'name' ]}").click
@browser.link( :text => 'Claim it now!' ).click

@browser.link( :text, 'Claim my business').click

code = PhoneVerify.ask_for_code(number)
