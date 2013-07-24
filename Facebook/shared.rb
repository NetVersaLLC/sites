def retry_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha
    @browser.text_field(:id=> 'reg_passwd__').set data['password']
    @browser.text_field(:id =>'captcha_response').set captcha_text
    @browser.button(:value =>'Sign Up Now!').click

     sleep(5)
    if not @browser.text.include? "You didn\'t correctly type the text in the security check box."
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

def login(data)
  if not @browser.link(:text => 'Logout').exist?
  @browser.text_field(:id => 'email').set data['email']
  @browser.text_field(:id => 'pass').set data['password']
  @browser.button(:value => 'Log In').click 
  end
end

def create_page(data)
  @browser.link(:text => 'Create a Page').click
  @browser.div(:text => 'Local Business or Place').when_present.click
  @browser.select_list(:id=> 'category').select data[ 'category' ]
  @browser.text_field(:name => 'page_name').set data[ 'business' ]
  @browser.text_field(:name => 'address').set data[ 'address' ]
  @browser.text_field(:name => 'city').set data['location'] 
  @browser.text_field(:name => 'city').click

  sleep 2
  Watir::Wait.until{@browser.li(:text => /#{data['city']}/i).exists?}
  @browser.li(:text => /#{data['city']}/i).click

  #@browser.text_field(:name => 'city').send_keys :down
  #@browser.text_field(:name => 'city').send_keys :enter
  #sleep 5
  #if @browser.span(:text => data['city'] ).exist?
  #  @browser.span(:text => data['city'] ).click
  #end
  @browser.text_field(:name => 'zip').set data[ 'zip' ]
  @browser.text_field(:name => 'phone').set data[ 'phone' ] 
  @browser.checkbox(:name => 'official_check').set
  @browser.button(:value => 'Get Started').click
  #Verify
  if not @browser.link(:text=> 'Create a new business account').exist?
    puts "Throwing Error..#{@browser.div(:id =>'create_error').text}"
  end
  
end