def update_business(data)
  tries ||= 5
  @browser.goto('http://www.yellowbrowser.com/update_Listings.php')
  @browser.text_field( :name => /visitor/).set data['full_name']
  @browser.text_field( :name => 'visitormail').set data[ 'email' ]
  @browser.text_field( :name => 'phone').set data[ 'phone' ]
  @browser.text_field( :name => 'fax').set data[ 'fax' ]
  @browser.text_field( :name => 'business').set data[ 'business' ]
  @browser.text_field( :name => 'address').set data[ 'address' ]
  @browser.text_field( :name => 'city').set data[ 'city' ]
  @browser.text_field( :name => 'state').set data[ 'state' ]
  @browser.text_field( :name => 'zip').set data[ 'zip' ]
  @browser.text_field( :name => 'keyword').set data[ 'category' ]
  @browser.text_field( :name => 'url').set data[ 'website' ]
  @browser.text_field( :name => 'notes').set data[ 'description' ]
  @browser.select_list( :name => 'attn').select "Listing Update Request"
  @browser.text_field(:name => 'fact').set data['reason_for_update']

  button = @browser.button(:name=>"Submit")
  field = @browser.text_field(:id=>"captcha")
  image = @browser.image(:id=>"phoca-captcha")
  enter_captcha(button,field,image,"has been received")
rescue => e
  if (tries -= 1) > 0
    puts "Yellowbrowser/UpdateListing failed. Retrying #{tries} more times."
    puts "Details: #{e.message}"
    sleep 2
    retry
  else
    puts "Yellowbrowser/UpdateListing failed. Out of retries. Quitting."
    raise e
  end
else
  puts "Yellowbrowser/UpdateListing successful!"
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

update_business(data)
