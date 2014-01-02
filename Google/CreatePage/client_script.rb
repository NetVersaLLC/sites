# This Payload is currently not being used.
# It left here for reference and possible future use.
# If other payloads chain to this one, please correct the matter.
# They should likely be chaining to CreateListing instead.

# Used for proper exception handling

class InvalidDashboard < StandardError
end

@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close 
  end
}

def login ( data )
  site = 'https://plus.google.com/u/0/pages/create'
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

def add_business_description( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  sleep 1
  @browser.element(:css => 'div.wb:nth-child(6)').when_present.click
  puts "Adding Business Description..."
  sleep 3
  @frame = @browser.frame(:id, /bfeSharedRichTextFieldId/)
  @frame.body(:id => /bfeSharedRichTextFieldId/).click
  @frame.body(:id => /bfeSharedRichTextFieldId/).send_keys data['description']
  sleep 2
  @browser.element(:css => '.dn').click
  puts "Description Set"
rescue => e
  unless @retries == 0
    puts "Error caught in add_business_description: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_description could not be resolved. Error: #{e.inspect}"
  end
end

def add_business_contact( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(3)').when_present.click
  puts "Adding Contact Information..."
  @browser.element(:css => '.vn').when_present.send_keys data['website']
  @browser.element(:css => '.Fv').send_keys data['email']
  sleep 1
  @browser.element(:css => 'div.on:nth-child(6) > div:nth-child(1)').click
  puts "Contact Information Set"
rescue => e
  unless @retries == 0
    puts "Error caught in add_business_contact: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_contact could not be resolved. Error: #{e.inspect}"
  end
end

def add_hours( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  puts "Adding Hours of Operation..."
  @browser.element(:css => 'div.wb:nth-child(5)').when_present.click
  7.times { 
    @browser.element(:css => '.Ov > div:nth-child(1)').click 
    sleep 0.5
  }
  data['hours'].each do |day,time|
    day = day.capitalize
    if time.nil? || time == ""
      puts "#{day} is closed"
    elsif time.first.nil? || time.first == ""
      puts "#{day}'s opening time is nil"
    elsif time.last.nil? || time.last == ""
      puts "#{day}'s closing time is nil"
    elsif not time.nil? || time == ""
      puts "Current Day: #{day}"
      if day == "Sunday"
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Sunday').click
        @list.divs(:class, 'c-X c-Ne').first.click
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Monday"
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Monday').click
        @list.divs(:class, 'c-X c-Ne')[1].click
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Tuesday"
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Tuesday').click
        @list.divs(:class, 'c-X c-Ne')[2].click
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Wednesday"
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Wednesday').click
        @list.divs(:class, 'c-X c-Ne')[3].click
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Thursday"
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Thursday').click
        @list.divs(:class, 'c-X c-Ne')[4].click
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Friday"
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Friday').click
        @list.divs(:class, 'c-X c-Ne')[5].click
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Saturday"
        @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Saturday').click
        @list.divs(:class, 'c-X c-Ne').last.click
        @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      end
    end
  end
@browser.element(:css => 'div.on:nth-child(3) > div:nth-child(1)').click  
sleep 5
puts "Hours of Operation Set"
rescue => e
  unless @retries == 0
    puts "Error caught in add_hours: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_hours could not be resolved. Error: #{e.inspect}"
  end
end

def create_page( data )
  unless @retries < 3
    @retries = 3
  end

  if @browser.text.include? "Verify your account"
    puts "Google's onto us! Hide!"
    ## For debug purposes ##
    @browser.element(:css => '.XShxJc').wait_until_present(300)
    ########################
    if @chained
      self.start("Google/Notify")
    end
  end

  @browser.element(:css => '.yid').click

  add_business_description( data )

  sleep 3

  add_business_contact( data )
  
  sleep 3

  add_hours( data )

rescue => e
  unless @retries == 0
    puts "Error caught in create_page: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in create_page could not be resolved. Error: #{e.inspect}"
  end
end

def goto_dashboard()

end

# Controller
@retries = 3
begin
  login( data )
  goto_dashboard()
    begin
      sleep 5
      if @browser.element(:css => '.yid').present?
        create_page( data )
      else
        raise InvalidDashboard
      end
    rescue InvalidDashboard
      unless @retries == 0
        puts "Dashboard not found, refreshing page..."
        @browser.refresh
        @retries -= 1
        retry
      else
        raise "Dashboard could not be found!"
      end
    end
  end

rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")

rescue Selenium::WebDriver::Error::ElementNotVisibleError => e
  puts e.inspect
  puts "Error encountered. Trying to ride it out..."
  #sleep  

end

if @chained
  self.start("Google/MailNotify", 10087) # Wait 7 days
end

puts "Payload Completed"
true