@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close 
  end
}

def login ( data )
  site = data['link']
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

def verify_business( data )
    unless @browser.url == data['link']
        @browser.goto data['link']
    end

    @browser.h4(:text, "#{data['business']}").when_present.click

    @browser.h3(:text, /Verify by phone or postcard/).wait_until_present

    if not @browser.text.include? 'No phone PIN requests left' then
      puts "Verifying by phone..."
      @browser.h4(:text, /Verify by phone/).click

      @browser.element(:css => '.FB').wait_until_present(60)

      code = PhoneVerify.retrieve_code("Google")
      @browser.element(:css => '.PmDmjc').send_keys code
      @browser.element(:css => '.MK').click

      sleep 10

      if @browser.text.include? 'The PIN you have entered is not correct.'
          puts "Incorrect code"
          if @chained
              self.start("Google/Notify")
          end
      elsif @brower.element(:css => '.PmDmjc').present?
          puts "Something weird is going on, did code submit?"
          throw "Unknown Error - Please Investigate Screenshot"
      end

      self.failure("Please verify that the business has verified.")
      self.save_account("Google", {:status => "Listing claimed, verification status pending."})

    else
      puts "No PIN attempts left, verifying by postcard..."
      @browser.h4(:text, /Verify by postcard/).click
      @browser.element(:css => '.JB').when_present.send_keys data['name']
      @browser.element(:css => '.QK').click
      @browser.element(:css => 'div.c-v-x:nth-child(3)').when_present.click
      if @chained
        self.start("Google/MailNotify", 10087) # Wait 7 days
      end
      self.success("Business is now in postcard verification process")
      self.save_account("Google", {:status => "Listing claimed, verify postcard will arrive in 1-2 weeks."})
    end

rescue => e
  unless @retries == 0
    puts "Error caught in verify_business: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in verify_business could not be resolved. Error: #{e.inspect}"
  end
end
# Main Controller
@retries = 3
login( data )
verify_business( data )
