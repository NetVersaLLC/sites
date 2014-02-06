@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

def login ( data )
  site = 'https://www.google.com/local/business'
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

def get_to_business( data )

  # Make SURE we're on the right page
  unless @browser.url == "https://www.google.com/local/business"
    @browser.goto "https://www.google.com/local/business"
  end

  if not @browser.text.include? "Complete your business information"
    @browser.element(:css, 'div.mu:nth-child(1) > div:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > a:nth-child(1) > div:nth-child(1)').when_present.click
  end

end

def update_business_contact( data)
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(3)').when_present.click
  puts "Adding Contact Information..."
  unless data['website'].nil?
    @browser.element(:css => '.vn').when_present.send_keys [:control, "a"], :backspace
    sleep 1
    @browser.element(:css => '.vn').send_keys data['website']
  end
  @browser.element(:css => '.Fv').send_keys [:control, "a"], :backspace
  sleep 1
  @browser.element(:css => '.Fv').send_keys data['email']
  if data['mobile?'] == true then
    @browser.element(:css => '.wc').click
    @browser.element(:css => '.Iv').when_present.send_keys [:control, "a"], :backspace
    sleep 1
    @browser.element(:css => '.Iv').send_keys data['mobile']
  end
  @browser.element(:css => '.dn').click
  puts "Contact Information Set"

  @browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
  sleep 3 # Saved
rescue => e
  unless @retries == 0
    puts "Error caught in update_business_contact: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_business_contact could not be resolved. Error: #{e.inspect}"
  end
end

def update_hours( data )
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(5)').when_present.click
  puts "Adding Hours of Operation..."
  sleep 2
  # Until used to delete existing hours
  until not @browser.element(:css => '.Ij').present?
    @browser.element(:css => '.Ij').click
  end
  8.times { 
    @browser.element(:css => '.Ov > div:nth-child(1)').click 
    sleep 0.5
  }
  # Delete re-added weekday field
  @browser.element(:css => '.Ij').click
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
        @browser.element(:css => 'div.zn:nth-child(1) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(1) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Sunday').click
        @list.divs(:class, 'c-X c-Ne').first.click
        @browser.element(:css => 'div.zn:nth-child(1) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(1) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Monday"
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Monday').click
        @list.divs(:class, 'c-X c-Ne')[1].click
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Tuesday"
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Tuesday').click
        @list.divs(:class, 'c-X c-Ne')[2].click
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Wednesday"
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Wednesday').click
        @list.divs(:class, 'c-X c-Ne')[3].click
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Thursday"
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Thursday').click
        @list.divs(:class, 'c-X c-Ne')[4].click
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Friday"
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Friday').click
        @list.divs(:class, 'c-X c-Ne')[5].click
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
      elsif day == "Saturday"
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > div:nth-child(5)')
        sleep 0.5
        #@browser.div(:text => 'Saturday').click
        @list.divs(:class, 'c-X c-Ne').last.click
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > input:nth-child(2)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > input:nth-child(4)').send_keys time.last
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
    puts "Error caught in update_hours: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_hours could not be resolved. Error: #{e.inspect}"
  end
end

def update_photos( data )
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
    puts "Error caught in update_photos: #{e.inspect}"
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

def update_business_description( data )
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
  @frame.body(:id => /bfeSharedRichTextFieldId/).send_keys [:control, 'a'], :backspace
  sleep 2
  @frame.body(:id => /bfeSharedRichTextFieldId/).send_keys data['description']
  sleep 2
  @browser.element(:css => 'div.on:nth-child(2) > div:nth-child(1)').click
  puts "Description Set"
rescue => e
  unless @retries == 0
    puts "Error caught in update_business_description: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_business_description could not be resolved. Error: #{e.inspect}"
  end
end

def update_business( data )
  #@browser.element(:css => '.tB').when_present.click
  Watir::Wait.until(60) { @browser.text.include? "Complete your business information" }
  
  unless @browser.url =~ /https:\/\/www\.google\.com\/local\/business\/edit/
    url = @browser.url
    url.sub!("business","business/edit")
    @browser.goto url
  end

  update_business_contact( data )

  update_hours( data )

  # Needs RAutomation support
  #update_photos( data )

  update_business_description( data )

  sleep 3 # Ensure stuff saves

rescue => e
  unless @retries == 0
    puts "Error caught in update_business: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_business could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
@retries = 3
login( data )
get_to_business( data )
update_business( data )
puts "Done"
self.save_account("Google", {:status => "Listing updated successfully!"})
self.success("Business updated successfully.")
