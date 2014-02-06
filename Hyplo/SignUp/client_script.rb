# Developer's Notes
# nil

# Browser code
@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

# Methods
def register_form(data)
  retries ||= 3
  @browser.goto("http://www.hyplo.com/account/signup.php")
  @browser.text_field( :id => 'email').set data[ 'email' ]
  @browser.text_field( :id => 'fn').set data[ 'fname' ]
  @browser.text_field( :id => 'ln').set data[ 'lname' ]
  @browser.text_field( :id => 'pw1').set data[ 'password' ]
  @browser.text_field( :id => 'pw2').set data[ 'password' ]
  @browser.checkbox( :id => 'nl').clear
  @browser.button( :value => 'Sign Up').click
  Watir::Wait.until { @browser.text.include? "Confirmation sent!" }
rescue => e
    retry unless (retries -= 1).zero?
    self.failure(e)
else
  puts "Registration Form Complete!"
  if @chained
    self.start("Hyplo/Verify")
  end
end

# Controller
register_form(data)
self.success
