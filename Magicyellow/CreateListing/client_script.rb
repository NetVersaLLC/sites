@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}
# td this is your business
#
def search_by_phone(data)
  @browser.text_field(:name => 'phone').set data[ 'phone' ]
  @browser.button(:value=> 'Search').click
  Watir::Wait.until do 
    @browser.td(:text => /No matches found/).exist? || @browser.td(:text => /this is your business/).exist?
  end
  @browser.td(:text => /this is your business/).exist?
end

#Claim business
def claim_business(data)
  if @browser.link(:text=> 'Claim This Business').exist?
    @browser.link(:text=> 'Claim This Business').click
    add_new_business(data)
  else
    puts "Business is already claimed"
  end
end

def sign_in(data)
  @browser.goto("http://www.magicyellow.com/login.cfm")
  @browser.text_field(:id => 'login').set data['email']
  @browser.text_field(:name => 'password').set data['password']
  @browser.button(:value => 'Submit').click
end

def captcha_text(image_element) 
  puts "captcha solving..."
  captcha_file_name = "#{ENV['USERPROFILE']}\\citation\\magicyellow_captcha.png"
  image_element.save captcha_file_name
  s = CAPTCHA.solve captcha_file_name, :manual
  puts "captcha solution #{s}" 
  s
end 

def add_new_business(data)
  @browser.link(:href => "#searchbox").click 
  sleep(2) 
  @browser.text_field(:id => "keyword").set data['business_category']
  @browser.button(:id => "searchsubmit").click
  sleep(2)

  @browser.b(:text => data['business_category']).checkbox.set
  @browser.button(:value => "Select").click
  sleep(1)

  @browser.text_field(:name => 'regNameRelation').set 'Owner'
  @browser.text_field(:name => 'OwnerNameFirst').set data[ 'first_name']
  @browser.text_field(:name => 'OwnerNameLast').set data[ 'last_name']
  @browser.text_field(:name => 'ContactPhone').set data[ 'phone']
  @browser.text_field(:name => 'ContactEmail').set data[ 'email']
  @browser.text_field(:name => 'lName').set data[ 'business']
  @browser.text_field(:name => 'lContact').value = data[ 'fullname' ]
  @browser.text_field(:name => 'lEmail').set data[ 'email']
  @browser.text_field(:name => 'lAddress').set data[ 'address']
  @browser.text_field(:name => 'lCity').set data[ 'city']
  @browser.select_list(:name => 'lState').select data[ 'state']
  @browser.text_field(:name => 'lZip').set data[ 'zip']
  @browser.text_field(:name => "websiteURL").set data['url']


  @browser.text_field(:name => 'describebiz').set data[ 'business_description']
  @browser.checkbox(:name => 'optin').set

  3.times do 
    captcha = captcha_text(@browser.image(:src => /captcha.cfm/))
    @browser.text_field(:name => 'captchaText').set captcha 
    @browser.execute_script('document.getElementsByName("Submit")[0].click();')

    puts "sleeping for 15"
    sleep(15)
    @browser.refresh unless @browser.td(:id => 'footer_logo').exist?

    break unless @browser.text.include? "did not match"
  end 

  unless @browser.text.include? "Services, Products, Brands"
    throw "Somethign went wrong while filling basic info"
  end

  @browser.text_field(:name => 'ServicesExtra').set data[ 'additional_services' ]
  @browser.text_field(:name => 'ProductsExtra').set data[ 'additional_products' ]
  @browser.text_field(:name => 'BrandsExtra').set data[ 'additional_brands' ]

  @browser.checkboxes(:name => 'biz_payment_option_type').each{|cb| cb.clear}
  data['payment_option'].each do |p|
    @browser.checkbox(:name => 'biz_payment_option_type', :value => p).set
  end 
  
  @browser.button(:value => 'Submit').click
  @success_msg = 'Thank you for claiming'
  if @browser.text.include?(@success_msg)
    puts "Initial registration is Successful"

    if @chained
      self.start("Magicyellow/Verify")
    end
    self.success

    true
  else
    throw "Initial registration is not Successful"
  end
end


#Main Steps
@browser.goto("http://www.magicyellow.com/add-your-business.cfm")
# Search for existing business by phone
if search_by_phone(data)
  claim_business(data)
else
  @browser.link(:text => 'Add Your Business').click
  add_new_business(data)
end
