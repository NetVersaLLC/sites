@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
	  @browser.close
	end
}
# Developer's Notes
# Good idea for listing site: mydeputy.net

def sign_up(data) 
  return true unless data['email'].to_s.empty? || data['password'].to_s.empty? 

  if sign_up_form(data) 
    self.save_account('Mysheriff', {:email => data['new_email'], :password => data['new_password'], :status => "Account created, posting listing..."})
    true
  else 
    reg_error = @browser.div('reg_error')
    if reg_error.exist? && reg_error.lis.count == 1 && reg_error.text.include?('image Correctly') 
      false 
    else
      raise "Error filling out form" 
    end
  end 
end 

def create_listing(data) 
  sign_in(data) 

  return true if @browser.link(:title => /Edit Details/).exist? 
  return true unless search_listing(data) 

  @browser.link(:text => /Add your business now/).click
  sleep(30)

  form = @browser.form(:name => "formAdd") 

  form.text_field(:id => "CompanyName").set data["business_name"] 
  form.text_field(:id => "Address").set data["address1"] 
  form.text_field(:id => "Address2").set data["address2"]
  form.text_field(:id => "zip").set data["zip"] 
  form.text_field(:id => "phone1").set data["phone"][0]
  form.text_field(:id => "phone2").set data["phone"][1]
  form.text_field(:id => "phone3").set data["phone"][2]
  form.text_field(:id => "WebsiteAddress").set data["website"] 
  form.text_field(:id => "EmailAddress").set data["email"]

  form.text_field(:name,'City').set data["city"]
  sleep(15)
  @browser.div(:class => 'ac_results').li(:text => /#{data['state']}/).click

  form.text_field(:name,'searchDescription').set data["category"]
  sleep(10)
  Watir::Wait.until { @browser.divs(:class => 'ac_results').length == 2 } 
  categories = @browser.divs(:class => 'ac_results')[1]
  categories.li(:text => /#{data['category']}/i).click

  form.button.click
  sleep(30)
  if @browser.text.include? "View Listing"
    self.save_account('Mysheriff', {
        "listing_url" => @browser.link(:text,/View Listing/).href,
        "status" => "Listing successfully created."
      })
    true
  else
    raise 'failed to create listing' 
  end
end 

def update_listing(data)

  sign_in(data) 

  @browser.goto("http://www.mysheriff.net/users/business/mybusiness/") 
  sleep(30) 

  @browser.link(:title => /Edit Details/).click
  @business_nav = @browser.div(:id => "busnav")
  sleep(20)

  listing_url = @browser.link(:text => /View Listing/).href,
  self.save_account('Mysheriff', { "listing_url" => listing_url, "status" => "Listing updated."})

  update_details(data) 
  update_about_us(data) 
  update_hours(data) 
  update_pricing(data) 
  update_image_gallery(data) 
  
  true
end 

def search_listing data
  sleep(5)
  @browser.link(:text,/add new business/).click
  sleep(5)

  form = @browser.form(:name => "formSearch")

  form.text_field(:id => 'business').set data["business_name"]
  form.text_field(:id => 'location').set data['zip']

  form.button(:value => "Search").click
  sleep(10)

  @browser.span(:text => /No results found/).exist?
end


def sign_up_form(data) 
  @browser.goto "http://www.mysheriff.net/users/"

  @browser.radio(:value => data['gender']).set

  add_user_form = @browser.form(:id => 'AddUser') 

  @browser.text_field(:name => 'firstname').set     data['first_name']
  @browser.text_field(:name => 'lastname').set      data['last_name']
  @browser.text_field(:name => 'email_address').set data['new_email']

  @browser.select_list(:name=>'cmbmonth').select    data['birthday']['month']
  @browser.select_list(:name=>'cmbday').select      data['birthday']['day']
  @browser.select_list(:name=>'cmbyear').select     data['birthday']['year']

  # city displays a drop down that you need to select from
  @browser.text_field(:name => 'City').set          data['city']
  sleep(5)
  @browser.div(:class => 'ac_results', :text => /#{data['city']}/).wait_until_present
  @browser.div(:class => 'ac_results').li(:text => /#{data['state']}/).click

  3.times do 
    add_user_form.text_field(:id   => 'password').set      data['new_password']
    @browser.text_field(:name => 'verif_box').set     solve_captcha( @browser.form(:id => 'AddUser').image )
    @browser.button(:value => 'Sign Up').click

    break if @browser.h1(:text => /Nice to see you/).exist?
    break if @browser.li(:text => /email address has already been used/).exist?
  end 
  @browser.h1(:text => /Nice to see you/).exist? || @browser.li(:text => /email address has already been used/).exist?
end 

def solve_captcha(image_element)
  image_file = "#{ENV['USERPROFILE']}\\citation\\mysheriff_captcha.png"
  puts "CAPTCHA width: #{image_element.width}"
  image_element.save image_file
  sleep(3)

  return CAPTCHA.solve image_file, :manual
end

def sign_in data
  @browser.goto 'www.mysheriff.net'
  sleep(30)

  if @browser.ul(:id => "nav").text.include? "Logout"
    puts "Already logged in. Proceeding."
  else
    login_form = @browser.form(:id => "loginForm")

    login_form.text_field(:id => 'login').set data["email"] 
    login_form.text_field(:id => 'password').set data["password"]
    login_form.button.click
    sleep(30)

    raise 'invalid login credentials' if @browser.span(:text =>  /Invalid Login/).exist?
  end
end

def update_details data
  @business_nav.link(:text => "Edit Details").click

  form = @browser.form(:name => "account") 

  @browser.text_field(:id => "CompanyName").set data["business_name"] 
  @browser.text_field(:id => "Address").set data["address1"] 
  @browser.text_field(:id => "Address2").set data["address2"]
  @browser.text_field(:id => "zip").set data["zip"] 
  @browser.text_field(:id => "phone1").set data["phone"][0]
  @browser.text_field(:id => "phone2").set data["phone"][1]
  @browser.text_field(:id => "phone3").set data["phone"][2]
  @browser.text_field(:id => "WebsiteAddress").set data["website"] 
  @browser.text_field(:id => "EmailAddress").set data["email"]

  form.text_field(:name,'City').set data["city"]
  @browser.div(:class => 'ac_results', :text => /#{data['city']}/).wait_until_present
  @browser.div(:class => 'ac_results').li(:text => /#{data['state']}/).click

  form.text_field(:name,'searchDescription').set data["category"]
  Watir::Wait.until { @browser.divs(:class => 'ac_results').length == 2 } 
  categories = @browser.divs(:class => 'ac_results')[1]
  categories.li(:text => /#{data['category']}/i).click

  form.button.click
  @browser.p(:text => /updated/).wait_until_present
end

def update_about_us data
  @business_nav.link(:text => "About Us").click
  @browser.textarea(:id => "about").set data["description"] 
  @browser.button(:id => 'updateAbout').click

  @browser.p(:text => /updated/).wait_until_present
end 

def update_hours(data) 
  @business_nav.link(:text => "Trading Hours").click

  form = @browser.form(:name => "trading") 
  form.select_lists.each do |select_list| 
    select_list.select data['hours'][select_list.name]
  end 
  form.button.click 

end 

def update_pricing(data) 
  @business_nav.link(:text => "Pricing").click

  form = @browser.form(:name => "prices") 
  form.checkboxes.each{|cb| cb.clear}
  data['payment_methods'].each do |payment_method| 
    form.checkbox(:id => payment_method).set 
  end 

  form.button.click 
end 

def update_image_gallery(data) 
  @business_nav.link(:text => "Image Gallery").click
  remove_existing_images
  upload_images(data)
end 

def remove_existing_images
  21.times do 
    break unless @browser.link(:text => "Edit").exists?
    @browser.link(:text => "Edit").click

    @browser.button(:id => "deleteImg").wait_until_present
    @browser.button(:id => "deleteImg").click
    @browser.alert.ok 

    remove_existing_images
  end
end

def upload_images( data )
  images.each do |p|
    f = File.join("#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images", p)
    puts "file #{f}"
    total_images = @browser.images.count

    @browser.file_field(:id => 'imgFile').value= f
    @browser.text_field(:id => 'imageTitle').set data["business_name"]
    @browser.button(:id => "uploadImg").click

    Watir::Wait.until(60){ @browser.images.count == total_images + 1 }
  end
end 

@heap = JSON.parse( data['heap'] ) 
if !@heap['images']
  self.start("Utils/ImageSync")
  self.start("Mysheriff/UpdateListing", 30)
  @heap['images'] = true
  self.save_account("Mysheriff", {"heap" => @heap.to_json})
else 
  unless @heap['signed_up']
    @heap['signed_up'] = sign_up(data) 
    self.save_account("Mysheriff", {"heap" => @heap.to_json})
  end 

  if @heap['signed_up'] && !@heap['listing_created']
    @heap['listing_created'] = create_listing(data) 
    self.save_account("Mysheriff", {"heap" => @heap.to_json})
  end 

  if @heap['listing_created']
    @heap['listing_updated']  = update_listing(data) 
    self.save_account("Mysheriff", {"heap" => @heap.to_json})
  end 

  unless @heap['signed_up'] && @heap['listing_created'] && !@heap['listing_updated'] 
    self.start("Mysheriff/UpdateListing", 1440)
  end 
end 
self.success
