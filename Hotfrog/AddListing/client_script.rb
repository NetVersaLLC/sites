#Get the validation error
def validation_error()
  page = Nokogiri.parse(@browser.html)
  page.css("p.error-msg").each do |error|
     puts error.text.gsub(/\t+|\r+|\n+/,'').strip
  end
end

#Method for add business
def add_new_business(data)
  #@browser.link(:text => 'Add your business').click
  @browser.text_field(:name => /BusinessName/).set data[ 'business']
  @browser.text_field(:name => /StreetAddress/).set data[ 'address']
  @browser.text_field(:name => /Suburb/).set data['city']
  @browser.text_field(:name => /Suburb/).send_keys :down
  @browser.text_field(:name => /Suburb/).send_keys :enter
  @browser.select_list(:name => /State/).option(:value => data['state']).select
  @browser.text_field(:name => /Postcode/).set data[ 'zip']
  @browser.text_field(:name => /Email/).set data[ 'email']
  @browser.text_field(:name => /Website/).set data[ 'website']
  @browser.text_field(:name => /Description/).set data[ 'business_description']
  @browser.text_field(:name => /Keywords/).set data[ 'keywords']
  @browser.link(:text=> 'Add keyword(s)').click
  @browser.text_field(:name => /FirstName/).set data[ 'first_name']
  @browser.text_field(:name => /LastName/).set data[ 'last_name']
  @browser.select_list(:name => /JobTitle/).select data[ 'job_title']
  @browser.text_field(:name => /AdminEmail/).set data[ 'email']
  @browser.text_field(:name => /txtPassword/).set data[ 'password']
  @browser.text_field(:name => /ConfirmPassword/).set data[ 'password']
  
  #Captcha Text
  enter_captcha(data)

  if @browser.text.include? "Your city and Zip code don't seem to match." then
  	@browser.text_field(:name => /Suburb/).set " " + data['city']
  	@browser.text_field(:name => /Suburb/).send_keys :enter
  	enter_captcha(data)
  end
 
  if @browser.text.include?("Thank you for joining Hotfrog")
    puts "Initial Registration is successful"
    self.save_account("Hotfrog", {:email => data['email'], :password => data['password']})
  else
    throw("Initial Registration is Unsuccessful")
    #Show error
    validation_error()
  end
end

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\hotfrog_captcha.png"
  obj = @browser.image(:src, /LanapCaptcha.aspx/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def enter_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha	
    @browser.text_field( :id, /ctl00_contentSection_CaptchaManager_ctl00_txtCaptcha/).set captcha_code
    @browser.link(:text=> 'Submit').click
    sleep(5)
    if not @browser.text.include? "The code you typed doesn't seem to match, please try again"
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

#Main Steps
# Launch browser
puts "Beginning browser code"
begin
  puts "Creating browser"
@browser = Watir::Browser.new :firefox
puts "Browser created"
@url = 'http://www.hotfrog.com/AddYourBusinessSingle.aspx'
@browser.goto(@url)
#@browser.link(:text => 'Add your business').click
add_new_business(data)

rescue Exception => e
  puts("Exception Caught in Business Listing")
  puts(e)
end

if @chained == true
  self.start("Hotfrog/Verify")
end

at_exit do
  unless @browser.nil?
    @browser.close
  end
end

true
