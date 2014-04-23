@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

def login(data)
  if not @browser.link(:text => 'Logout').exist?
  @browser.text_field(:id => 'email').set data['email']
  @browser.text_field(:id => 'pass').set data['password']
  @browser.button(:value => 'Log In').click 
  end
end

#Create business page
def update_list(data)
  @browser.goto "https://www.facebook.com/bookmarks/pages"
  @browser.element(:css, 'ul.mts:nth-child(1) > li:nth-child(1) > a:nth-child(2)').when_present.click
  @browser.element(:css, 'span.selectorItem:nth-child(1) > div:nth-child(1) > div:nth-child(1) > a:nth-child(1)').when_present.click
  @browser.element(:css, 'div.uiSelectorMenuWrapper:nth-child(3) > div:nth-child(1) > ul:nth-child(1) > li:nth-child(1) > a:nth-child(1)').when_present.click
  #Update address
  update_category(data)
  #update_address(data)
  update_hours(data)
  update_description(data)
  update_email(data)
  update_website(data)
end

def update_address(data)
  @browser.link(:href => /section\=address/).span(:text=> 'Edit').when_present.click
  @browser.text_field(:name=>/location__address/).when_present.set data['address']
  @browser.text_field(:name=>/location__city/).set data['location']
  sleep 2
  @browser.send_keys :arrow_down
  @browser.text_field(:name=>/location__city/).send_keys :tab
  @browser.text_field(:name=>/location__zip/).set data['zip']
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
end

def update_description(data)
  @browser.link(:href => /long_desc/).when_present.click
  @browser.text_field(:class=> 'uiTextareaNoResize').when_present.set data[ 'business_description' ] 
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
  sleep 2
end

def update_email(data)
  @browser.link(:href => /section\=email/).when_present.click
  @browser.text_field(:name => /email/).when_present.set data['email']
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
  sleep 2
end
  
def update_website(data)
  sleep 2
  @browser.link(:href => /section\=website/).when_present.click
  @browser.text_field(:name => /website/).when_present.set data['website']
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
  sleep 10
end

def update_category(data)
  # Ensure categories are correct
  unless @browser.text.include? data['profile_category']
    @browser.h3(:text, /Category/).when_present.click
    @browser.select_list(:id, 'profile_super_category').when_present.select "Local Businesses"
    @browser.select_list(:id, 'profile_category').select data['profile_category']
    @browser.button(:value, 'Save Changes').click
  end # Category may already be set, if so, skip
rescue => e
  puts e
  retries ||= 3
  unless retries == 0
    @browser.refresh
    retries -= 1
    retry 
  else
    raise(e)
  end
end

def update_hours(data)
  days = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun'
]
  @browser.h3(:text, /Hours/).click
  unless data[ '24hours' ]
    for day in days
      if data[ "#{day}_enab" ] == true
        @browser.link(:class => "uiButton", :text => "Add Hours").when_present.click
        @browser.button(:value, "#{day.capitalize}").when_present.click
        @browser.text_field(:name, 'time_1_display_time').set data[ "#{day}_open" ]
        @browser.text_field(:name, 'time_2_display_time').set data[ "#{day}_close" ]
        sleep 1
        @browser.text_field(:name, 'time_2_display_time').send_keys :tab # Registers field input
        sleep 2
        @browser.label(:class => /hoursEditorSubmitButton/).click
      end
    end
  else
    @browser.radio(:value, 'always_open').set
  end
  @browser.button(:value, 'Save Changes').click
  sleep 5 # Make sure things save
rescue => e
  puts e
  retries ||= 3
  unless retries == 0
    if @browser.label(:class, /uiCloseButtonSmall/).present?
      until @browser.label(:class, /uiCloseButtonSmall/).present? == false 
        @browser.label(:class, /uiCloseButtonSmall/).click
        sleep 2
      end
    end
    @browser.refresh
    retries -= 1
    retry 
  else
    raise(e)
  end
end

#Main steps

begin

@browser.goto "www.facebook.com"
login(data)
update_list(data)
self.success

rescue Exception => e
    puts "Caught a #{e.message}"
end