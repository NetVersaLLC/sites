def signup
  tries ||= 5
  @url = 'https://www.staylocal.org/node/add/business-listing'
  @browser.goto(@url)

  @browser.text_field(:name => 'name').set data[ 'username' ]
  @browser.text_field(:name => 'mail').set data[ 'email' ]
  @browser.text_field(:name => 'pass[pass1]').set data[ 'password' ]
  @browser.text_field(:name => 'pass[pass2]').set data[ 'password' ]
  @browser.text_field(:name => 'title').set data[ 'business' ]
  @browser.text_field(:name => /street/).set data[ 'address' ]
  @browser.text_field(:name => /city/).set data[ 'city' ]
  @browser.text_field(:id => /province/).set data[ 'state' ]
  @browser.text_field(:id => /province/).send_keys :tab

  @browser.text_field(:name => /postal_code/).set data[ 'zip' ]
  @browser.text_field(:name => /phone/).set data[ 'phone' ]
  @browser.text_field(:name => /business_owner/).set data[ 'full_name' ]
  @browser.text_field(:name => /business_owner_email/).set data[ 'email' ]
  @browser.text_field(:name => /description/).set data[ 'business_description' ]
  @browser.text_field(:name => /keywords/).set data[ 'keywords' ]
  @browser.select_list(:id => /edit-taxonomy-4/).option(:text => /#{data[ 'category' ]}/).click
  @browser.select_list(:id => /edit-taxonomy-2/).select data[ 'parish' ]
  button = @browser.input(:id=>"edit-submit")
  field = @browser.text_field(:id=>"recaptcha_response_field")
  image = @browser.div(:id=>"recaptcha_image").image
  enter_captcha(button,field,image,"A validation e-mail has been sent to your e-mail address")
rescue
  if (tries -= 1) > 0
    puts "Could not sign up to Staylocal. Retrying #{tries} more times."
    retry
  else
    puts "Could not sign up to Staylocal. Out of retries. Quitting."
    false
  end
else
  puts "Job Staylocal/Signup success!"
  true
end

@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end
#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha( button, field, image, successTrigger, failureTrigger=nil )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha(image)
    field.set captcha_code
    button.click
    
    if failureTrigger.nil? or not @browser.text.include? failureTrigger
      capSolved = true
    end
    
  count+=1  
  end
  if capSolved == true
    Watir::Wait.until { @browser.text.include? successTrigger }
    true
  else
    throw("Captcha was not solved")
  end
end
#END CAPTCHA

signup