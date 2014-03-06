@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
	  @browser.close
	end
}


def sign_up(data) 
  return true unless data['email'].empty? && data['password'].empty? 

  @browser.goto 'https://www.getfave.com/login'
  sleep(30)
  @browser.link(:text,'create a new one,').click
  sleep(30)

  @browser.text_field(:id,'user_name').set data[ 'name' ]
  @browser.text_field(:id,'user_email').set data[ 'email' ]

  @browser.text_field(:id,'user_password').set data[ 'new_password' ]
  @browser.button(:value,'Join Us').click

  if @browser.text.include? 'Email is already taken'
  elsif @browser.text.include? "can't be blank"
    raise "Required fields can not be blank."
  elsif @browser.label(:class, "error").present?
    raise "There is an error while creating the account"	
  else 
    self.save_account("Getfave", {:email => data['email'], :password => data['password'], :status => "Account created, verifying account..."})
    puts "Signup successful. Verifying email to continue"
  end
  
  true
end 

def verify_account(data) 

  # have to use scripts because using @browser.link or @browser.span returns permission errors 
  # 2014-03-04 15:47:02: Failure: [remote server] https://a.gfx.ms/Shared_76rpP9xhgs1VwFct9hxN3w2.js:1:in `r': Permission denied to access property '__qosId'
  click_fave_email =   "var fave = /Activate Your Fave Account/; 
    var spans; 
    spans = document.getElementsByClassName('Sb');
    for (var i=0;i<spans.length;i++) { 
      var s; 
      s = spans[i];
      if(fave.exec(s.textContent)){ 
        s.click(); 
        return true; 
      }
    }
    return false;"

  get_verify_link =   "var go_here = /go here/; 
    var spans; 
    spans = document.getElementsByTagName('a');
    for (var i=0;i<spans.length;i++) { 
      var s; 
      s = spans[i];
      if(go_here.exec(s.textContent)){ 
        return s.href; 
      }
    }
    return;"

  @browser.goto("https://mail.live.com/") 
  sleep(30)
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  sleep(30)

  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
    sleep(30)
  end 

  return unless @browser.execute_script(click_fave_email) 
  sleep(30)

  href = @browser.execute_script(get_verify_link) 
  raise('could not find verification link in the email') unless href

  @browser.goto(href)
  sleep(30)
  if @browser.link(:text => "Log Out").exist?
    self.save_account("Getfave", {:status => "Account verified successfully. Creating listing..."})
    true
  else 
    false
  end
end

def create_listing(data) 
  sign_in(data) 
  change_location(data)

  @browser.text_field(:id => "q").set data['business']
  @browser.button(:value => "Get").click
  sleep(15)
  Watir::Wait.until { @browser.div(:id => 'results').exists? }

  if @browser.text.include? "We couldn't find any matches."
    @browser.link(:href => 'https://www.getfave.com/businesses/new').click
    sleep(15)
    fill_business data
    listing_url = get_listing_url(data)
  elsif @browser.div(:id => 'business-results').span(:text => "#{data['business']}").exist?
    listing_url = @browser.div(:id => 'business-results').span(:text => "#{data['business']}").parent.href
    # TODO claim???
  end 

  self.save_account("Getfave", {:listing_url => listing_url, :status => "Listing status pending."})
  true
end 

def update_listing(data) 

  sign_in(data)

  @browser.link(:text => "Businesses" ).click
  sleep(15)
  @browser.h1(:text => "Managed Businesses").wait_until_present

  @browser.link(:text => 'Edit Information').click
  sleep(30)
  fill_business data

  true
end 

def get_listing_url(data)
  @browser.link(:text => "Businesses" ).click
  sleep(15)
  @browser.h1(:text => "Managed Businesses").wait_until_present
  @browser.link(:text => data['business']).href
end 

def sign_in(data)
  return if @browser.link(:text => "Log Out").exist?

  @browser.goto 'https://www.getfave.com/login'

  @browser.link(:text => 'Log In/Join').click
  @browser.text_field(:id => 'session_email').wait_until_present

  @browser.text_field(:id => 'session_email').set data['email']
  @browser.text_field(:id => 'session_password').set data['password']
  @browser.button(:value => 'Log In').click
  sleep(20) 
  Watir::Wait.until{ @browser.div(:id => "footer-links").text =~ /Log Out/ }
end

def change_location(data)
  @browser.link(:id => 'change-location').wait_until_present
  @browser.link(:id => 'change-location').click
  @browser.text_field(:id => 'g-text-field').set data['city'] + ", " + data['state']
  @browser.text_field(:id => 'g-text-field').send_keys :enter

  Watir::Wait.until{ !@browser.div(:id => "location").text.empty? }
end



def fill_business(data)
  @browser.text_field(:id => 'business_name').set data['business']
  #puts('Debug: Name Set')
  @browser.text_field(:id => 'business_location').set data['address']
  #puts('Debug: Address Set')
  @browser.text_field(:id => 'business_phone_number').set data['phone']
  #puts('Debug: Phone Set')
  @browser.text_field(:id => 'business_tags').set data['keywords']
  #puts('Debug: Tags Set')
  #Some brief Javascript as Ruby fails
  @browser.execute_script("
  jQuery('a#edit-more.result-style').trigger('click') 
  ")
  sleep(10);

  Watir::Wait.until { @browser.text_field(:id => 'business_established').exists? }

  @browser.text_field(:id => 'business_established').set data['year']
  #puts('Debug: Year Set')
  @browser.text_field(:id => 'business_tagline').set data['tagline']
  #puts('Debug: Tagline Set')
  @browser.text_field(:id => 'business_description').set data['discription']
  #puts('Debug: Description Set')
  @browser.text_field(:id => 'business_url').set data['url']
  #puts('Debug: Website Set')
  @browser.text_field(:id => 'business_email').set data['business_email']
  #puts('Debug: Email Set')
  @browser.text_field(:id => 'business_hours').set data['business_hours']
  #puts('Debug: Hours Set')
  @browser.button(:value => 'Publish Changes').click
  #puts('Debug: Changes Published')
  sleep(30)
  raise Exception, @browser.element(:class => 'error').text if @browser.element(:class => 'error').exist?
rescue => e
  unless @retries == 0
    puts "Error caught in fill_business: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    @browser.refresh
    retry
  else
    raise "Error in fill_business could not be resolved. Error: #{e.inspect}"
  end
end

@heap = JSON.parse( data['heap'] ) 

unless @heap[:signed_up] 
  @heap[:signed_up] = sign_up(data)        
  self.save_account("Getfave", {"heap" => @heap.to_json})
end 

unless @heap[:account_verified]
  @heap[:account_verified] = verify_account(data) 
  self.save_account("Getfave", {"heap" => @heap.to_json})
end 

if @heap[:account_verified] && !@heap[:listing_created]
  @heap[:listing_created]  = create_listing(data) 
  self.save_account("Getfave", {"heap" => @heap.to_json})
end 

if @heap[:listing_created]
  @heap[:listing_updated]  = update_listing(data) 
  self.save_account("Getfave", {"heap" => @heap.to_json})
end 

unless @heap[:signed_up] && @heap[:account_verified] && @heap[:listing_created] && @heap[:listing_updated] 
  self.start("Getfave/UpdateListing", 60)
end 
self.success

