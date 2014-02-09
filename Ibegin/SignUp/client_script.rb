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
def registration(data)
  @browser.goto('http://www.ibegin.com/account/register/')
  @browser.text_field( :name, 'name').set data[ 'username' ]
  @browser.text_field( :name, 'liame').set data[ 'email' ]
  @browser.text_field( :name, 'pw' ).set data[ 'password' ]
  @browser.button( :value, /Register/i).click

  Watir::Wait.until { @browser.text.include? "Business owners - over a million people view these listings every month" or @browser.lis(:style => 'color:red;').size > 0 }

  if @browser.lis(:style => 'color:red;').size > 0
    @browser.lis(:style => 'color:red;').each do |error|
      raise(error.text)
    end
  else
    self.save_account("Ibegin", {:email => data['email'], :username => data['username'], :password => data['password'], :status => "Account created, creating listing..."})
    if @chained
      self.start("Ibegin/CreateListing")
    end
    self.success
  end
rescue => e
  unless @retries == 0
    puts "Error caught in registration: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in registration could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
@retries = 3
registration(data)
