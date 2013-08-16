def retry_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha
    if captcha_text == nil
      raise StandardError.new("Captcha does not exist")
    end
    if @browser.text_field(:id=> 'reg_passwd__').exists?
      @browser.text_field(:id=> 'reg_passwd__').set data['password']
    end
    @browser.text_field(:id =>'captcha_response').set captcha_text
    if @browser.button(:value =>'Sign Up Now!').exists?
      @browser.button(:value =>'Sign Up Now!').click
    elsif @browser.button(:name, "submit[Submit]").exists?
      @browser.button(:name, "submit[Submit]").click
    else
      throw("Submittal could not be compeleted")
    end

     sleep(5)
    if @browser.text.include? "Please provide a response for the security check."
      puts("No text entered. Retrying.")
    elsif not @browser.text.include? "The text you entered didn't match the security check. Please try again."
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
  if obj.exists?
    puts("GoogleCaptcha exists")
    puts "CAPTCHA source: #{obj.src}"
    puts "CAPTCHA width: #{obj.width}"
    obj.save image
    captcha_text = CAPTCHA.solve image, :manual
    return captcha_text
  else
    puts("GoogleCaptcha does not exist")
    return nil
  end
end

def retry_verify_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_verify_captcha
    @browser.text_field(:name=> 'captcha_response').set captcha_text
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

def solve_verify_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\google_captcha.png"
  obj = @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/)
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
  @browser.link(:text => 'Create a Page').when_present.click
  @browser.div(:text => 'Local Business or Place').when_present.click
  @browser.select_list(:id=> 'category').select data[ 'profile_category' ]
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
  sleep(3)
  #Verify
  #if not @browser.link(:text=> 'Create a new business account').exist?
  # puts "Throwing Error..#{@browser.div(:id =>'create_error').text}"
  #end
  if @browser.text.include? "Please choose a different name or go to your current Page."
    @browser.link(:text, "go to your current Page").click
    sleep(2)
  end
end