#require 'rautomation'

# Used for proper exception handling

class InvalidDashboard < StandardError
end

@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close 
  end
}

# Many methods in the finish_business methods are identical
# However, they are left seperated in the event that google
# makes significant changes to either of them and to catch
# possible discrepencies. 

# Please be aware that there ARE some discrepencies.

# That said, if you feel that it is a safe bet to optimize
# this code by combining the similar methods and calling them
# from different places, feel free.

# Login
def login ( data )
  site = 'https://www.google.com/local/business/add'
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

# No longer used, left for reference
# Upload photo on google profile
def photo_upload_pop(data)
  require 'rautomation'
  #update logo
  @browser.div(:class => 'G8iV4').when_present.click
  @browser.div(:class => /o7Daxc g-s-Sa-Cr/).when_present.click
  @browser.div(:text => 'Select a photo from your computer').when_present.click
  data['logo'] = self.logo
  if data['logo'] > 0
    photo_upload_pop = RAutomation::Window.new :title => /File Upload/
    photo_upload_pop.text_field(:class => "Edit").set(data['logo'])
    photo_upload_pop.button(:value => "&Open").click
    @browser.wait_until {@browser.div(:text => 'Set as profile photo').visible? }
    @browser.div(:text => 'Set as profile photo').click
    @browser.button(:value => 'Cancel').when_present.click
  end

  #update other images
  pic = self.images
  data[ 'images' ] = pic
  @browser.div(:text => 'Change cover').when_present.click
  @browser.div(:text => 'Upload').when_present.click
  @browser.div(:text => 'Select a photo from your computer').when_present.click
  if pic.length > 0
    image_index = ""
    for image_index in (0..pic.length-1)
      photo_upload_pop = RAutomation::Window.new :title => /File Upload/
      photo_upload_pop.text_field(:class => "Edit").set(pic[image_index])
      photo_upload_pop.button(:value => "&Open").click
      @browser.wait_until {@browser.div(:text => 'Select cover photo').visible? }
      @browser.div(:text => 'Select cover photo').click
    end
  end
end

def check_scenarios( data )
  businessFound = false
  # Check for different scenarios
  if @browser.text.include? "Is this your business?"
    # Scenario 1
    @scenario = 1
    puts "Single Business Scenario"
    if @browser.h4(:text, "#{data['business']}").exists? then
      puts "Match Found!"
      businessFound = true
    end
  elsif @browser.text.include? "Is one of these your business?"
    # Scenario 2
    @scenario = 2
    puts "Multiple Businesses Scenario"
    count = 1
    until count == 4
      if @browser.h4(:text, "#{data['business']}").exists? then
        puts "Match Found!"
        businessFound = true
        break
      end
      count += 1
    end
  elsif @browser.text.include? "We could not find"
    # Scenario 3
    @scenario = 3
    puts "No Results Scenario"
  end
  return businessFound
end

def search_business( data )

  unless @browser.url =~ /https:\/\/www\.google\.com\/local\/business\/add/
    @browser.goto "https://www.google.com/local/business/add"
  end
  
  if @browser.div(:class => "W0 pBa").exist? && @browser.div(:class => "W0 pBa").visible?
    @browser.div(:class => "W0 pBa").click
  end

  #@browser.div(:text, 'Local Business or Place').when_present.click

  if @browser.text_field(:id => 'Passwd').exist?
    @browser.text_field(:id => 'Passwd').set data['pass'] if @browser.text_field(:id => 'Passwd').exist?
    @browser.button(:value, "Sign in").click
    sleep(3)
  end

  if @browser.element(:css => '.b-U-yd').present?
    @browser.element(:css => '.b-U-yd').click
    @browser.element(:css => '.Am').click
  end
  
  puts "Searching for business..."
  @browser.text_field(:placeholder, 'Search for your business…').when_present.set data['business'] + ", " + data['state'] + ' ' + data['city']
  @browser.img(:src, /search-white/).click
  puts "Checking result scenarios..."
  @browser.element(:css => '.I0vWDf').wait_until_present(60)
  sleep 3 # Just in case some elements haven't loaded yet
end

def handle_scenarios()
  # Handle Result Scenario
  puts "Handling Results Scenario..."
  if @scenario == 1 then
    @browser.h4(:text, "No, this is not my business").click
  elsif @scenario == 2 then
    @browser.h4(:text, "No, these are not my businesses").click
  elsif @scenario == 3 then
    @browser.h4(:text, "I've correctly entered the business and address").click
  else
    raise "Invalid Result Scenario"
  end

  puts "Scenario #{@scenario.to_s} handled."
end

def initial_signup_form( data )
  unless @retries < 3
    @retries = 3
  end
  puts 'Creating business listing'
  # Basic Information, xpath used for reliability
  @browser.element(:css => 'input.Cj:nth-child(2)').when_present.send_keys data['business']
  puts "Business set"
  #Skip Country/Region
  @browser.element(:css => 'div.Xq:nth-child(2) > input:nth-child(2)').send_keys data['address']
  @browser.element(:css => '.OO').send_keys data['city']
  # Set State      
  puts "Selecting State..."
  @browser.element(:css, '.aP > div:nth-child(1)').click
  sleep 1
  @browser.divs(:class, 'c-X').each do |state|
    if state.text == data['state']
      puts "#{state.text} Selected"
      state.click
      break
    end
  end
  @browser.execute_script("
      document.getElementsByTagName('input')[4].disabled=false;
      document.getElementsByTagName('input')[5].disabled=false;
      document.getElementsByTagName('input')[6].disabled=false;
    ")
  sleep 2
  @browser.element(:css => '.cP').send_keys data['zip'].to_s
  puts "Zip set"
  @browser.element(:css => 'input.Cj:nth-child(1)').send_keys data['phone']
  puts "Phone Set"
  @browser.element(:css => '.mg').send_keys data['category']
  @browser.divs(:class, 'Ic-ed').each do |category|
    if category.b.exists?
      cat = category.text + category.b.text
    else
      cat = category.text
    end
    if cat =~ /#{data['category']}/ then
      category.click
    end
  end
  @browser.div(:text, 'Submit').click
rescue => e
  unless @retries == 0
    puts "Error caught in initial_signup_form: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in initial_signup_form could not be resolved. Error: #{e.inspect}"
  end
end

def postcard_verify( data )
  @browser.element(:css => 'div.Id:nth-child(1)').when_present.click
  @browser.element(:css => '.sf8V7e > div:nth-child(3) > input:nth-child(1)').when_present.send_keys data['name']
  @browser.element(:css => '.sf8V7e > div:nth-child(3) > div:nth-child(2) > div:nth-child(1)').click
  
  @browser.element(:css => '.EHnaC').when_present.click #Continue
  sleep 3
  if @browser.element(:css => '.b-P-Tb').present?
    @browser.element(:css => '.b-P-Tb').click
    @browser.element(:css => '.d-Cb-Ba').click
  end
  puts "Page Successfully Created"
end

def add_business_description_1( data )
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
    puts "Error caught in add_business_description_1: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_description_1 could not be resolved. Error: #{e.inspect}"
  end
end

def add_business_contact_1( data )
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
    puts "Error caught in add_business_contact_1: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_contact_1 could not be resolved. Error: #{e.inspect}"
  end
end

def add_hours_1( data )
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
    puts "Error caught in add_hours_1: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_hours_1 could not be resolved. Error: #{e.inspect}"
  end
end


def finish_business_1( data )
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

  @browser.element(:css => '.yid').when_present.click

  add_business_description_1( data )

  sleep 3

  add_business_contact_1( data )
  
  sleep 3

  add_hours_1( data )

rescue => e
  unless @retries == 0
    puts "Error caught in finish_business_1: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in finish_business_1 could not be resolved. Error: #{e.inspect}"
  end
end

def add_business_contact_2( data)
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(3)').when_present.click
  puts "Adding Contact Information..."
  unless data['website'].nil?
    @browser.element(:css => '.vn').when_present.send_keys data['website']
  end
  if data['mobile?'] == true then
    @browser.element(:css => '.wc').click
    @browser.element(:css => '.Iv').when_present.send_keys data['mobile']
  end
  @browser.element(:css => '.dn').click
  puts "Contact Information Set"

  @browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
  sleep 3 # Saved
rescue => e
  unless @retries == 0
    puts "Error caught in add_business_contact_2: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_contact_2 could not be resolved. Error: #{e.inspect}"
  end
end

def add_hours_2( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(5)').when_present.click
  puts "Adding Hours of Operation..."
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

@browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
sleep 3 # Saved
rescue => e
  unless @retries == 0
    puts "Error caught in add_hours_2: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_hours_2 could not be resolved. Error: #{e.inspect}"
  end
end

def add_photos_2( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(6)').when_present.click
  puts "Adding Business Photos..."
  @browser.element(:css => '.a-kb-vA > div:nth-child(4) > div:nth-child(1)').when_present.click
  data['logo'] = self.logo
  if data['logo'] > 0
    sleep 1
    photo_upload_pop = RAutomation::Window.new :title => /File Upload/
    photo_upload_pop.text_field(:class => "Edit").set(data['logo'])
    photo_upload_pop.button(:value => "&Open").click
    @browser.element(:css => '#picker:ap:2').wait_until_present(120)
  end

  # Additional images
  photos = self.images
  data[ 'images' ] = photos
  @browser.element(:css => '#picker:ap:2').click
  sleep 1
  if photos.length > 0
    image_index = ""
    for image_index in (0..photos.length-1)
      photo_upload_pop = RAutomation::Window.new :title => /File Upload/
      photo_upload_pop.text_field(:class => "Edit").set(photos[image_index])
      photo_upload_pop.button(:value => "&Open").click
      @browser.element(:css => '#picker:ap:2').wait_until_present(120)
    end
  end
  @browser.element(:css => '#picker:ap:0').click

  @browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
  sleep 3 # Saved

rescue => e
  unless @retries == 0
    puts "Error caught in add_photos_2: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    puts "Photos could not be added successfully. Skipping..."
    @browser.refresh
    sleep 3
  end
end

def add_business_description_2( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(7)').when_present.click
  sleep 3
  @frame = @browser.frame(:id, /bfeSharedRichTextFieldId/)
  @frame.body(:id => /bfeSharedRichTextFieldId/).click
  @frame.body(:id => /bfeSharedRichTextFieldId/).send_keys data['description']
  sleep 2
  @browser.element(:css => 'div.on:nth-child(2) > div:nth-child(1)').click
  puts "Description Set"
rescue => e
  unless @retries == 0
    puts "Error caught in add_business_description_2: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_description_2 could not be resolved. Error: #{e.inspect}"
  end
end

def finish_business_2( data )
  @browser.element(:css => '.rB').when_present.click

  add_business_contact_2( data )

  add_hours_2( data )

  # Needs RAutomation support
  add_photos_2( data )

  add_business_description_2( data )

rescue => e
  unless @retries == 0
    puts "Error caught in finish_business_2: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in finish_business_2 could not be resolved. Error: #{e.inspect}"
  end
end

def check_dashboard_type()
  sleep 5 # Bonus time for elements to load
  if @browser.element(:css => '.rB').present?
    return 2
  elsif @browser.element(:css => '.yid').present?
    return 1
  end
end

#Main Steps
@retries = 3
begin
  login( data )
  search_business( data )
  if check_scenarios( data ) == true
    if @chained
      self.start("Google/ClaimListing")
    end
  else
    handle_scenarios()
    initial_signup_form( data )
    postcard_verify( data )
    begin
      if check_dashboard_type() == 1
        puts "Dashboard Type 1"
        finish_business_1( data )
      elsif check_dashboard_type() == 2
        puts "Dashboard Type 2"
        finish_business_2( data )
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
        raise "Invalid Dashboard or Dashboard not found!"
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