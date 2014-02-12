@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

# Temporary methods from Shared.rb

def solve_captcha
  image = ["#{ENV['USERPROFILE']}",'\citation\adyp_captcha.png'].join
  obj = @browser.img(:alt => "CAPTCHA")
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  puts "CAPTCHAT stored at: #{image}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def step_1_basic(data)
  @browser.goto("https://adsolutions.yp.com/listings/basic")

  @browser.text_field(:id => 'BusinessPhoneNumber').set data['phone']
  @browser.text_field(:id => 'BusinessName').set data['business']
  @browser.text_field(:id => 'BusinessOwnerFirstName').set data['fname']
  @browser.text_field(:id => 'BusinessOwnerLastName').set data['lname']
  @browser.text_field(:id => 'Email').set data['email']

  @browser.text_field(:id => 'txtCategories').send_keys data['category'][0..3]
  @browser.link(:text => data['category']).wait_until_present
  @browser.link(:text => data['category']).click

  @browser.text_field(:id => 'BusinessAddress_Address1').set data['address']
  @browser.text_field(:id => 'BusinessAddress_City').set data['city']
  @browser.select_list(:id => 'BusinessAddress_State').select data['state']
  @browser.text_field(:id => 'BusinessAddress_Zipcode').set data['zip']
  @browser.text_field(:id => 'BusinessYear').set data['founded']

  @browser.image(:alt => 'continue').click

  @browser.div(:id => "searchResultsDiv").wait_until_present
end 


def step_2_details(data)
  @browser.link(:id => 'selectLink').click

  data['payments'].each do |pay|
    @browser.checkbox(:id => pay).clear
    @browser.checkbox(:id => pay).click
  end

  3.times do
    @browser.text_field(:id => "captcha").set solve_captcha
    @browser.div(:class=>'buttonContainer30').button.click

    break if @browser.div(:text => /Sign Up/).exist?
  end
  raise "failed to solve captcha" unless @browser.div(:text => /Sign Up/).exist?
end 

def step_3_registration(data)
  @browser.text_field(:id => 'RepeatEmail').when_present.set data['email']
  @browser.text_field(:id => 'Password').set data['password']
  @browser.text_field(:id => 'RepeatPassword').set data['password']
  @browser.select_list(:id => 'SecurityQuestion').select "What is your mother's maiden name?"
  @browser.text_field(:id => 'SecurityAnswer').set data['secret_answer']

  @browser.checkbox(:id => 'TermsOfUse').click

  @browser.button(:id => 'submitButton').click

  Watir::Wait.until(60) {@browser.text.include? "Your listing will not be displayed on YP.com until you have completed verification."}
end 

step_1_basic(data) 
step_2_details(data) 
step_3_registration(data)

self.save_account("Adsolutionsyp", { :email => data['email'], :password => data['password']})

if @chained
	self.start("Adsolutionsyp/Notify")
end

true

