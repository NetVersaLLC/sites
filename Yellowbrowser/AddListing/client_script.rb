def signup (data)
  tries ||= 5
  @browser.goto( 'http://yellowbrowser.com/add_business.php' )

  @browser.text_field( :name => 'visitor').set data[ 'fullname' ]
  @browser.text_field( :name => 'visitor').fire_event('onBlur')
  @browser.text_field( :name => 'visitormail').set data[ 'email' ]
  @browser.text_field( :name => 'visitormail').fire_event('onBlur')
  @browser.text_field( :name => 'phone').set data[ 'phone' ]
  @browser.text_field( :name => 'phone').fire_event('onBlur')
  @browser.text_field( :name => 'fax').set data[ 'fax' ]
  @browser.text_field( :name => 'fax').fire_event('onBlur')
  @browser.text_field( :name => 'business').set data[ 'business' ]
  @browser.text_field( :name => 'business').fire_event('onBlur')
  @browser.text_field( :name => 'address').set data[ 'addressComb' ]
  @browser.text_field( :name => 'address').fire_event('onBlur')
  @browser.text_field( :name => 'city').set data[ 'city' ]
  @browser.text_field( :name => 'city').fire_event('onBlur')
  @browser.text_field( :name => 'state').set data[ 'state' ]
  @browser.text_field( :name => 'state').fire_event('onBlur')
  @browser.text_field( :name => 'zip').set data[ 'zip' ]
  @browser.text_field( :name => 'zip').fire_event('onBlur')
  @browser.text_field( :name => 'keyword').set data[ 'category' ]
  @browser.text_field( :name => 'keyword').fire_event('onBlur')
  @browser.text_field( :name => 'url').set data[ 'website' ]
  @browser.text_field( :name => 'url').fire_event('onBlur')
  @browser.text_field( :name => 'notes').set data[ 'description' ]
  @browser.text_field( :name => 'notes').fire_event('onBlur')
  @browser.select_list( :name => 'attn').select "New Listing Request"
  @browser.select_list( :name => 'attn').fire_event('onBlur')

  button = @browser.button(:name=>"Submit")
  field = @browser.text_field(:id=>"captcha")
  image = @browser.image(:id=>"phoca-captcha")
  enter_captcha(button,field,image,"has been received")
rescue => e
  if (tries -= 1) > 0
    puts "Yellowbrowser/AddListing failed. Retrying #{tries} more times."
    puts "Details: #{e.message}"
    sleep 2
    retry
  else
    puts "Yellowbrowser/AddListing failed. Out of retries. Quitting."
    puts "Details: #{e.message}"
    raise e
  end
else
  puts "Yellowbrowser/AddListing succeeded!"
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

signup data