@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

def solve_verify_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\facebook_captcha.png"
  if @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/).exists?
    obj = @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/)
  elsif @browser.image(:src, /recaptcha\/api\/image/).exists?
    obj = @browser.image(:src, /recaptcha\/api\/image/)
  else
    throw "A wild new captcha appears!"
  end
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def retry_verify_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_verify_captcha
    @browser.text_field(:name=> 'captcha_response').when_present.set captcha_text
    @browser.button(:name =>'submit[Submit]').click

     sleep(5)
    if not @browser.text.include? "The text you entered didn't match the security check. Please try again."
      capSolved = true
    end
    count+=1
   end
  if capSolved == true
    true
  else
  throw("Captcha was not solved")
  end
end

def login(data)
  if not @browser.link(:text => 'Logout').exist?
  @browser.text_field(:id => 'email').set data['email']
  @browser.text_field(:id => 'pass').set data['password']
  @browser.button(:value => 'Log In').click 
  end
end

def create_page(data)
  @browser.goto "https://www.facebook.com/pages/create"
  @browser.element(:css, '.sx_6bc4a1').click
  sleep 2
  @browser.select_list(:id, 'category').select data['profile_category']
  @browser.text_field(:id, 'local_business_form_page_name').set data[ 'business' ]
  @browser.text_field(:name, 'address').set data[ 'address' ] 
  @browser.text_field(:id, 'city').set data['location']
  sleep 2
  @browser.send_keys :arrow_down
  @browser.text_field(:id, 'city').send_keys :tab
  @browser.text_field(:name, 'zip').set data[ 'zip' ]
  @browser.text_field(:name, 'phone').set data[ 'phone' ] 
  @browser.checkbox(:name, 'official_check').click
  @browser.button(:value, 'Get Started').click
rescue => e
  retries ||= 3
  unless retries == 0
    retries -= 1
    retry 
  else
    raise(e)
  end
end

def about(data)
  # Remove previous categories due to a retry
  if @browser.link(:class, /uiCloseButtonSmall/).present?
    until @browser.link(:class, /uiCloseButtonSmall/).present? == false
      @browser.link(:class, /uiCloseButtonSmall/).click
    end
  end
  Watir::Wait.until { @browser.text_field(:name, 'blurb').present? }
  # Add new category, send tab to add it
  if @browser.text_field(:id, 'u_0_2').present?
    @browser.text_field(:id, 'u_0_2').send_keys data['category']
    sleep 2
    @browser.text_field(:id, 'u_0_2').send_keys :tab
  end
  # Add business description
  @browser.text_field(:name, 'blurb').set data[ 'business_description' ]
  # Add website if exists
  if not data[ 'website' ].nil?
    @browser.text_field(:name, /website/).set data[ 'website' ]
  end
  # Set page web address
  # Seems to randomly cause errors
  #@browser.text_field(:id, 'nax_username').set @waddress
  # "Is this real?" radio, true
  @browser.radio(:value => "no", :name => "is_community").set
  # "Is this a legal representative?" radio, true
  @browser.radio(:value => "yes", :name => 'is_authentic').set
  # Save info
  @browser.button(:value, 'Save Info').click
rescue => e
  puts e
  retries ||= 3
  unless retries == 0
    retries -= 1
    retry 
  else
    raise(e)
  end
end
  
def profile_picture(data)
  # TODO
  # Continue to moving_on(data) for now
rescue => e
  puts e
  retries ||= 3
  unless retries == 0
    retries -= 1
    retry 
  else
    raise(e)
  end
end

def moving_on(data)
  @browser.element(:css, '#u_0_2 > span:nth-child(1)').when_present.click
  @browser.link(:id, 'u_0_7').when_present.click
  @browser.span(:text, /Skip/).when_present.click
rescue => e
  puts e
  @browser.goto("https://www.facebook.com/#{@waddress}")
end

def bypass_introduction()
  @browser.link(:text, /Skip/).wait_until_present
  until @browser.link(:text, /Skip/).present? == false
    @browser.link(:text, /Skip/).click
    sleep 2
  end
end 

def update_page(data)
  @browser.element(:css, 'span.selectorItem:nth-child(1) > div:nth-child(1) > div:nth-child(1) > a:nth-child(1)').click
  @browser.element(:css, 'div.uiSelectorMenuWrapper:nth-child(3) > div:nth-child(1) > ul:nth-child(1) > li:nth-child(1) > a:nth-child(1)').when_present.click
  begin
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
  sleep 2
  begin
    # Add year founded
    @browser.h3(:text, /Start Info/).click
    @browser.select_list(:name, /anchor_date_field/).when_present.select "Founded"
    @browser.link(:text, 'Add year').click
    @browser.select_list(:class, /yearMenu/).when_present.select data[ 'year_founded']
    @browser.button(:value, 'Save Changes').click
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
  sleep 2
  begin
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
end

#Main Steps
@browser.goto "https://www.facebook.com/pages/create"
login(data)
create_page(data)
@waddress = data[ 'waddress' ]
about(data)
profile_picture(data)
moving_on(data)
bypass_introduction()
update_page(data)
self.success("Page was created successfully.")