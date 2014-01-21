class InvalidCode < StandardError  
end  
@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close 
  end
}

def login ( data )
  site = 'https://www.google.com/local/business/'
  @browser.goto site
  
  if !!@browser.html['Recommended places']
    puts "Already Logged in?"
    return true # Already logged in
  end
  
  page = Nokogiri::HTML(@browser.html)

  #if not page.at_css('div.signin-box') # Check for <div class="signin-box">
  #  @browser.link(:text => 'Sign in').click
  #end

  if !data['email'].empty? and !data['pass'].empty?
    @browser.text_field(:id, "Email").set data['email']
    @browser.text_field(:id, "Passwd").set data['pass']
    @browser.button(:value, "Sign in").click
    sleep(5)
    # If user name or password is not correct
      if @browser.span(:id => 'errormsg_0_Passwd').exist?
        if @browser.span(:id => 'errormsg_0_Passwd').visible?
        end
      end
  else
    raise StandardError.new("You must provide both a username AND password for gplus_login!")
  end
end

def enter_pin( data )
  unless @browser.url == "https://www.google.com/local/business/"
    @browser.goto "https://www.google.com/local/business/"
  end
  @browser.element(:css => 'div.mu:nth-child(1) > div:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > a:nth-child(2)').when_present.click
  @browser.element(:css => 'div.Kac0vf:nth-child(15) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > a:nth-child(4)').when_present.click
  @browser.element(:css => '.b-Ca').wait_until_present
  code = PhoneVerify.retrieve_code("Google")
  @browser.element(:css => '.b-Ca').send_keys code
  @browser.element(:css => 'div.b-d:nth-child(2)').click
  sleep 5
  if !!@browser.html['The PIN you have entered is not correct.']
    raise InvalidCode
  else
    sleep 20 # Success page not yet seen
  end
rescue InvalidCode
  puts "Invalid Code!"
  #PhoneVerify.wrong_code("Google")
  if @chained
    self.start("Google/MailNotify")
  end
  #@retries -= 1
  #retry

rescue Selenium::WebDriver::Error::InvalidElementStateError
  puts "No more PIN attempts left, requesting a new PIN..."
  @browser.element(:css => '.SgBDve').click
  @browser.element(:css => '.Id').when_present.click
  @browser.element(:css => 'div.Id:nth-child(1)').when_present.click
  @browser.element(:css => '.JB').when_present.send_keys data['name']
  @browser.element(:css => '.QK').click
  @browser.element(:css => 'div.c-v-x:nth-child(3)').when_present.click
  @browser.element(:css => '.rB').wait_until_present
  puts "New PIN requested. Please allow 1-2 weeks for delivery."
  if @chained
    self.start("Google/MailNotify", 10087) # Wait 7 days
  end

rescue StandardError => e
  unless @retries == 0
    puts "Error caught in enter_pin: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in enter_pin could not be resolved. Error: #{e.inspect}"
  end
end


# Main Controller
@retries = 5
login( data )
enter_pin( data )
self.save_account("Google", {:status => "Listing verified successfully."})

true
