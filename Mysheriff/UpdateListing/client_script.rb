# Developer's Notes
# Good idea for listing site: mydeputy.net

# Setup
at_exit{ @browser.close unless @browser.nil? }

def prerequisites(data)
  unless data['images_synced'] 
    self.start("Mysheriff/UpdateListing", 10) 
    return "Utils/ImageSync"
  end 
  return "Mysheriff/SignUp" if data['email'].to_s.empty? || data['password'].to_s.empty?
  nil
end 

def update(data)
  @browser = Watir::Browser.new :firefox
  @browser.goto 'www.mysheriff.net'

  sign_in(data) 

  return self.start("Mysheriff/CreateListing") unless @browser.link(:title => /Edit Details/).exist?

  @browser.link(:title => /Edit Details/).click
  @business_nav = @browser.div(:id => "busnav")

  update_details(data) 
  update_about_us(data) 
  update_hours(data) 
  update_pricing(data) 
  update_image_gallery(data) 
  
  listing_url = @browser.link(:text => /View Listing/).href,
  self.save_account('Mysheriff', { "listing_url" => listing_url, "status" => "Listing updated."})
end 


def sign_in data
  if @browser.ul(:id => "nav").text.include? "Logout"
    puts "Already logged in. Proceeding."
  else
    login_form = @browser.form(:id => "loginForm")

    login_form.text_field(:id => 'login').set data["email"] 
    login_form.text_field(:id => 'password').set data["password"]
    login_form.button.click

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

pre = prerequisites(data)
if pre 
  self.start( pre ) 
else 
  update(data)
end

self.success
