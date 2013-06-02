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
  @browser.wait_until { @browser.span(:text =>'Key to ratings').exist? == true}
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
    @browser.div(:class => 'a-f-e c-b c-b-M BNa').when_present.click
    @browser.wait()
    @browser.checkbox(:id, 'gwt-uid-50').when_present.set #terms
    @browser.link(:text,'Send postcard').click
    sleep(5)
    if @browser.div(:id=> 'send-mailer-success-dialog-box').text.include?('You should receive a postcard with your PIN in about a week.')
      puts "Initial business listing is successful"
      @browser.link(:text => 'OK').click
      true
    end
  end
end
