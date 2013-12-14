@browser = Watir::Browser.new :firefox

at_exit do
  @browser.close unless @browser.nil?
end

# BEGIN temp methods from shared.rb #
# Login
def login ( data )
  site = 'https://plus.google.com/local'
  @browser.goto site
  
  if !!@browser.html['Recommended places']
    return true # Already logged in
  end
  
  page = Nokogiri::HTML(@browser.html)

  if not page.at_css('div.signin-box') # Check for <div class="signin-box">
    @browser.link(:text => 'Sign in').click
  end

  if !data['email'].empty? and !data['pass'].empty?
    @browser.text_field(:id, "Email").set data['email']
    @browser.text_field(:id, "Passwd").set data['pass']
    @browser.button(:value, "Sign in").click
    sleep(5)
    # If user name or password is not correct
      if @browser.span(:id => 'errormsg_0_Passwd').exist?
        if @browser.span(:id => 'errormsg_0_Passwd').visible?
  signup_generic( data )
        end
      end
  else
    raise StandardError.new("You must provide both a username AND password for gplus_login!")
  end
end

#Search for busienss
def search_for_business( data )

  puts 'Search for the ' + data[ 'business' ] + ' business at ' + data[ 'zip' ] + data['city']

  #Close pop up if exist
  if @browser.div(:class => 'U-L-Y U-L-Y-tm').button(:name => 'continue').exist? and @browser.div(:class => 'U-L-Y U-L-Y-tm').button(:name => 'continue').visible?
    @browser.div(:class => 'U-L-Y U-L-Y-tm').button(:name => 'continue').click
  end

  #Upgrade the account
  if @browser.div(:class => 'BSa TVa').exist? && @browser.div(:class => 'BSa TVa').visible?
     @browser.div(:class => 'BSa TVa').click
     if @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').exist? && @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').visible?
     @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').when_present.click until @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').exist? == false
     end
  end

  # 'https://plus.google.com/local' ) # Must be logged in to search
  @browser.goto('https://plus.google.com/local')
  @browser.text_field(:name, "qc").when_present.set data['business']
  @browser.text_field(:name, "qb").when_present.set data['city']
  @browser.button(:id,'gbqfb').when_present.click
  @browser.wait_until { @browser.text.include?('Loading...') == false}
  #@browser.wait_until { @browser.span(:text =>'Key to ratings').exist? == true}
end

#Verify phone
def verify_phone(data)
  if @browser.text_field(:id, 'signupidvinput').exist?
    @browser.text_field(:id, 'signupidvinput').when_present.set data[ 'phone' ]
    @browser.radio(:id,'signupidvmethod-voice').set
    @browser.button(:value,'Continue').click
    # fetch Phone verification code
    @code = PhoneVerify.ask_for_code
    if @browser.span(:class,'errormsg').exist?
      puts "#{@browser.span(:class,'errormsg').text}"
    end
    if @browser.text_field(:id,'verify-phone-input').exist?
      @browser.text_field(:id,'verify-phone-input').when_present.set @code
      @browser.button(:value,'Continue').click
        if @browser.span(:class,'errormsg').exist?
        puts "#{@browser.span(:class,'errormsg').text}"
        end
    end
  end
end

#Parse result
def parse_results( data )
  #Parse search result page
  page = Nokogiri::HTML(@browser.html)
  page_links = page.css("a").select
  applicableLinks = {}
  page_links.each do |link|
   if not link.nil?
     if not link['href'].nil? and !!link['href']["/about"]
       img = ""
       if not link.at('img').nil?
         img = link.at('img')['src']
       end
       applicableLinks[link.content] = [link['href'], img]
     end
   end
  end
  return applicableLinks.to_a
end

def discern_parse_business_exist?( applicableLinks, data)
  return applicableLinks.collect { |listing| listing[0] == data['business'] }.member?(true)
end

def retry_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha	
    @browser.text_field(:id, "Passwd").value = data['pass']
    @browser.text_field(:id, "PasswdAgain").value = data['pass']
    @browser.text_field( :id => 'recaptcha_response_field' ).set captcha_text
    @browser.checkbox(:id => 'TermsOfService').set
    @browser.button(:value, 'Next step').click

     sleep(5)
    if not @browser.text.include? "The characters that you entered didn't match the word verification"
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

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\google_captcha.png"
  obj = @browser.image(:src, /recaptcha\/api\/image/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

#verify business
def verify_business()
  if @browser.text.include?('Verify your business')
    puts "Sending request for verification"
    @browser.checkbox(:id, /gwt-uid/).when_present.set #terms
    @browser.link(:text,'Send postcard').click
    sleep(5)
    if @browser.div(:id=> 'send-mailer-success-dialog-box').text.include?('You should receive a postcard with your PIN in about a week.')
      puts "Initial business listing is successful"
      @browser.link(:text => 'OK').click
    end
 true 
  end
end

# END temp methods from shared.rb #

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

#Create new business
def create_business( data )

  puts 'Business is not found - Creating business listing'
  @browser.goto "https://plus.google.com/pages/create"
  
  if @browser.div(:class => "W0 pBa").exist? && @browser.div(:class => "W0 pBa").visible?
    @browser.div(:class => "W0 pBa").click
  end
  
  @browser.div(:class => 'AX kFa a-yb Vn a-f-e a-u-q-b').when_present.click
  @browser.div(:text => "#{data['country']}").when_present.click
  @browser.text_field(:class, 'RBa Vn xBa c-cc LB-G ia-G-ia').when_present.set data['phone']
  @browser.div(:class => "a-f-e c-b c-b-M LC").when_present.click

  while not @browser.div(:class, "zX").exists? # No matches located
    sleep(3)
    puts 'Waiting on "No matches located" to appear.'
  end

  # Basic Information
  @browser.div(:class => "rta Si").click
  @browser.text_field(:xpath, "//input[contains(@label, 'Enter your business name')]").when_present.set data['business']
  @browser.text_field(:xpath, "//input[contains(@label, 'Enter your full business address')]").set data['address']
  @browser.text_field(:class=>'c-cc g9jP6 M3LyOb').set data['category']
  @browser.button(:name, 'ok').click
  @browser.text_field(:name => 'PlusPageName').when_present.set data['business']
  @browser.text_field(:name => 'Website').set data['website']
  @browser.div(:class => 'goog-inline-block goog-flat-menu-button-dropdown').click
  @browser.div(:text => 'Any Google+ user').click
  @browser.checkbox(:name => 'TermsOfService').set
  @browser.button(:value => 'Continue').click

  verify_phone(data)
  
  @browser.div(:class => 'a-f-e c-b c-b-M Bl').when_present.click if @browser.div(:class => 'a-f-e c-b c-b-M Bl').exist?
        
  #Signin if it aski
  if @browser.text_field(:id => 'Passwd').exist?
    @browser.text_field(:id => 'Passwd').set data['pass']
    @browser.button(:value, "Sign in").click
    @browser.wait()
  end
  
  if @browser.wait_until {@browser.div(:class=> 'iph-dialog-dismiss-container').exist? }
@browser.button(:value => 'Next').click until @browser.button(:value => 'Next').exist? == false
@browser.button(:value => 'Done').click
  end

  #edit busienss information
  @browser.wait_until { @browser.div(:class => 'a-f-e c-b c-b-M FEjGyb lMPaj').exist?}
  @browser.div(:class => 'a-f-e c-b c-b-M FEjGyb lMPaj').click

  if @browser.text_field(:id => 'Passwd').exist?
    @browser.text_field(:id => 'Passwd').set data['pass'] if @browser.text_field(:id => 'Passwd').exist?
    @browser.button(:value, "Sign in").click
    sleep(3)
  end

  # Update Address
  puts "Updating Address"
  @browser.span(:text => 'About').click if @browser.span(:text => 'About').exist?
  @browser.div(:text => 'Edit business information').click if @browser.div(:text => 'Edit business information').exist?
  @browser.div(:text=> 'Address').click
  @browser.text_field(:class => 'b-Ca Qf NO').when_present.set data['address']
  @browser.text_field(:class => 'b-Ca Qf OO').when_present.set data['city']
  @browser.div(:class => "Qf aP c-v-x c-y-i-d rXcQNd-lh-la rXcQNd-lh-la-fW01td-Df1uke").when_present.click
  sleep(2)
  @browser.div(:text=> "#{data['state']}").when_present.click
  @browser.text_field(:class => 'b-Ca Qf cP').when_present.set data['zip']
  @browser.div(:text=> 'Save').click

  #edit busienss information
  puts "Updating Business Description"

  #Edit description
  @browser.div(:text=> 'Description').when_present.click
  @browser.frame(:class => 'Lj editable').body(:class => 'editable').when_present.send_keys data[ 'business_description' ]
  @browser.div(:text=> 'Save').when_present.click
  @browser.div(:text=> 'Done editing').click if @browser.div(:text=> 'Done editing').exist?
  sleep(5)

 #Update Photo
  puts "Update Photo"
  photo_upload_pop(data)

  #Verify Business
  if @browser.span(:text=> 'Verify').exist?
    @browser.span(:text=> 'Verify').when_present.click
  elsif @browser.div(:text => "Verify now").exist?
    @browser.div(:text => "Verify now").when_present.click
  end

  verify_business()
end

#Verify phone
def verify_phone(data)
  if @browser.text_field(:id, 'signupidvinput').exist?
    @browser.text_field(:id, 'signupidvinput').when_present.set data[ 'phone' ]
    @browser.radio(:id,'signupidvmethod-voice').set
    @browser.button(:value,'Continue').click
    # fetch Phone verification code
    @code = PhoneVerify.ask_for_code
    if @browser.span(:class,'errormsg').exist?
      puts "#{@browser.span(:class,'errormsg').text}"
    end
    if @browser.text_field(:id,'verify-phone-input').exist?
      @browser.text_field(:id,'verify-phone-input').when_present.set @code
      @browser.button(:value,'Continue').click
        if @browser.span(:class,'errormsg').exist?
        puts "#{@browser.span(:class,'errormsg').text}"
        end
    end
  end
end

def match_business(data)
  page = Nokogiri::parse(@browser.html)
  businessFound = false
  page.css("h3.drb").each do |item|
    if item.text =~ /#data['business']/i
      businessFound = true
    end
  end
  return businessFound
end

#Main Steps
begin
  login( data )
  search_for_business( data )
  if @browser.html.include?('No results')
    puts "Create a new business"
    create_business( data )
  elsif match_business(data)
    puts "Create a new business"
    create_business( data )
  end

rescue
  if @browser.div(:class => 'passwd-div').text_field(:id => 'Passwd').exist?
    login(data)
  retry
 end

rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")
  retry

rescue Exception => e
    puts "Caught a #{e.message}"
end

