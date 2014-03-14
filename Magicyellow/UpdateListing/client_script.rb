@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end



def search_by_phone(data)
  @browser.text_field(:name => 'phone').set data[ 'phone' ]
  @browser.button(:value=> 'Search').click
  Watir::Wait.until do 
    @browser.td(:text => /No matches found/).exist? || @browser.link(:text=> 'Claim This Business').exist?
  end
  @browser.link(:text=> 'Claim This Business').exist?
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


def captcha_text(image_element) 
  puts "captcha solving..."
  captcha_file_name = "#{ENV['USERPROFILE']}\\citation\\magicyellow_captcha.png"
  image_element.save captcha_file_name
  sleep(5)
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
  @browser.text_field(:id => 'contactemail').set data[ 'email']
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
    sleep(30)
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
  @success_msg = 'Thank you for'
  if @browser.text.include?(@success_msg)
    puts "Initial registration is Successful"
    true
  else
    throw "Initial registration is not Successful"
  end
end


def create_listing(data) 
  @browser.goto("http://www.magicyellow.com/add-your-business.cfm")
  sleep(30)

  if search_by_phone(data)
    claim_business(data)
  else
    @browser.link(:text => 'Add Your Business').click
    add_new_business(data)
  end
  true 
end 

def verify_account(data) 
  
  click_email =   "var fave = /MagicYellow.com Business Center Login/; 
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
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  sleep(30)

  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
    sleep(30)
  end 

  found = @browser.execute_script( click_email )
  if found 
    puts 'email found'
    sleep(30)
    email_text = @browser.execute_script("return document.getElementsByTagName('pre')[0].textContent;")
    password = email_text.match(/Password: (\S{6})/)[1]
	  self.save_account("Magicyellow", {:email => data['email'], :password => password })
    data['password'] = password
    true
  else 
    false  
  end 
end 

def sign_in(data)
  @browser.goto("http://www.magicyellow.com/login.cfm")

  @browser.text_field(:id => 'login').set data['email']
  @browser.text_field(:name => 'password').set data['password']
  @browser.button(:value => 'Submit').click
  sleep(15)
end

def remove_images 
  delete = @browser.link(:text => "Delete")
  if delete.exist?
    delete.click
    remove_images
  end 
end 

def update_listing(data)
  sign_in(data)

  @browser.link(:href => /bizcentereditprofile/).click

  @browser.text_field(:name => 'ServicesExtra').set data[ 'additional_services' ]
  @browser.text_field(:name => 'ProductsExtra').set data[ 'additional_products' ]
  @browser.text_field(:name => 'BrandsExtra').set data[ 'additional_brands' ]

  @browser.checkboxes(:name => 'biz_payment_option_type').each{|cb| cb.clear}
  data['payment_option'].each do |p|
    @browser.checkbox(:name => 'biz_payment_option_type', :value => p).set
  end 
  @browser.button(:value => 'Save').click

  @browser.link(:href => /bizcenterphotos/).click
  bizid = @browser.url.match(/bizid=(\d+)\z/)[1]
  remove_images

  @browser.goto "http://www.magicyellow.com/bizcenterphotos_manual.cfm?bizid=#{bizid}"
  self.images.each do |p|
    f = File.join("#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images", p)
    puts "sending image #{f}"
    @browser.file_field(:name => 'img1').set f 
    @browser.button(:value => "Upload selected files!").click
  end 
  @browser.goto "http://www.magicyellow.com/bizcenter.cfm"

  listing_url = @browser.link(:href => /\/profile/).href
  self.save_account("Magicyellow", {:listing_url => listing_url, :status => "Listing updated."})
  true
end 

@heap = JSON.parse( data['heap'] ) 
if !@heap['images']
  self.start("Utils/ImageSync")
  self.start("Magicyellow/UpdateListing", 30)
  @heap['images'] = true
  self.save_account("Magicyellow", {"heap" => @heap.to_json})
else 
  unless @heap['listing_created']
    @heap['listing_created'] = create_listing(data) 
    self.save_account("Magicyellow", {"heap" => @heap.to_json})
  end 

  if @heap['listing_created'] &&  !@heap['account_verified']
    @heap['account_verified'] = verify_account(data) 
    self.save_account("Magicyellow", {"heap" => @heap.to_json})
  end 

  if @heap['account_verified']
    @heap['listing_updated']  = update_listing(data) 
    self.save_account("Magicyellow", {"heap" => @heap.to_json})
  end 

  unless @heap['account_verified'] && @heap['listing_created'] && @heap['listing_updated'] 
    self.start("Magicyellow/UpdateListing", 1440)
  end 
end 
self.success

