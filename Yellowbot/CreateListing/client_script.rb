@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def sign_in(data)
  @browser.goto("https://www.yellowbot.com/signin")
  @browser.text_field( :name => 'login').set data['email']
  @browser.text_field( :name => 'password').set data['password']
  @browser.button( :name => 'subbtn').click
end

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowbot2_captcha.png"
  obj = @browser.image(:id  => "recaptcha_challenge_image")
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

#Add business
def add_business(data)
  @browser.goto( 'http://www.yellowbot.com/submit/newbusiness' )

  @browser.text_field( :name, 'name').set data['business']
  @browser.text_field( :name, 'phone_number').set data['phone']
  @browser.text_field( :name, 'address').set data['address']
  @browser.text_field( :name, 'fax_number').set data['fax_number']
  Watir::Wait.until { @browser.alert.exists? }
  @browser.alert.ok

  @browser.text_field( :name, 'city_name').set data['city_name']
  @browser.select_list( :name, 'state').select data['state']
  @browser.text_field( :name, 'zip').set data['zip']
  @browser.text_field( :name, 'tollfree_number').set data['tollfree_number']
  @browser.text_field( :name, 'hours_open').set data['hours_open']
  @browser.text_field( :name, 'email').set data['email']
  @browser.text_field( :name, 'website').set data['website']

  3.times do 
    @browser.text_field( :name, 'recaptcha_response_field').set( solve_captcha() )
    @browser.button( :name, 'subbtn').click
    break if @browser.strong(:text => /Thank you/).exist?
  end
end


sign_in(data)
add_business(data)
raise( 'Errors trying to create business') unless @browser.strong(:text => /Thank you/).exist?
  
true
