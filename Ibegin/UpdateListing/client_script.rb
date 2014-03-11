@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
	  @browser.close
	end
}

def sign_up(data) 
  return true unless data['username'].to_s.empty? || data['email'].to_s.empty? || data['password'].to_s.empty?

  @browser.goto('http://www.ibegin.com/account/register/')
  @browser.text_field( :name, 'name').set data[ 'new_username' ]
  @browser.text_field( :name, 'liame').set data[ 'new_email' ]
  @browser.text_field( :name, 'pw' ).set data[ 'new_password' ]
  @browser.button( :value, /Register/i).click

  sleep(30)

  if @browser.link(:text => /logout/i).exist?
    self.save_account("Ibegin", {:email => data['new_email'], :username => data['new_username'], :password => data['new_password'], :status => "Account created, creating listing..."})
    true
  elsif @browser.ul(:text => /already registered/).exist?
    raise "Account already registered and will need a manual password reset at iBegin."
  else
    raise 'sign up failed. Unexpected response.'
  end 
end

def sign_in( data )
  return true if @browser.link(:text => /logout/i).exist?

  @browser.goto( 'http://www.ibegin.com/account/login/' )
  @browser.text_field( :name, 'name' ).set data['email']
  @browser.text_field( :name, 'pw' ).set data['password']

  @browser.button( :value, /Login/i).click
  sleep(30)
  @browser.link(:text => /logout/i).exists? 
end

def create_listing(data) 
  return false unless sign_in(data)

  @browser.goto('http://www.ibegin.com/business-center/submit/')
  sleep(30)
  @browser.text_field( :name, 'name').set data['business_name']

  @browser.select_list( :id, 'country').select data['country']

  Watir::Wait.until{ @browser.select(:id => 'region').options.count >= 50 } 
  @browser.select_list( :id, 'region').select data['state_name']

  Watir::Wait.until{ @browser.select(:id => 'city').options.count >= 5 } 
  @browser.select_list( :id, 'city').select data['city']

  @browser.text_field( :name, 'address').set data['address']
  @browser.text_field( :name, 'zip').set data['zip']
  @browser.text_field( :name, 'phone').set data['phone']
  @browser.text_field( :name, 'fax').set data['fax']
  @browser.text_field( :name, 'url').set data['url']
  @browser.text_field( :name, 'desc').set data['desc']
  @browser.text_field( :name, 'brands').set data['brands']
  @browser.text_field( :name, 'services').set data['services']

  category = data['category']
  puts category
  @browser.execute_script( 'document.getElementsByName("category1")[0].value="' + category +'";') 
  puts "category set" 
  
  data[ 'payment_methods' ].each{ | method |
      @browser.checkbox( :id => /#{method}/ ).clear
    }
  sleep(3)

  data[ 'payment_methods' ].each{ | method |
      @browser.checkbox( :id => /#{method}/ ).set
    }
  @browser.button( :value => /Submit Business/).click

  sleep(30)

  @browser.text.include? "Congratulations"
end 

def update_listing(data)
  return false unless sign_in(data)

  @browser.goto("http://www.ibegin.com/business-center/")
  sleep(30)

  # check if verification needed 
  if @browser.link(:text => /Claim Now/i).exist?
    @heap['phone_verified'] = false
    self.start("Ibegin/Notify")
    self.save_account("Ibegin", { :status => "Listing created successfully. Phone verification needed." })
    return false
  end 


  Watir::Wait.until {@browser.text.include? "Business Center"}

  @browser.link( :text => 'Edit Listing').click

  Watir::Wait.until { @browser.text.include? "Business Information" }

  @browser.text_field( :name, 'name').set data['business_name']
  @browser.select_list( :id, 'country').select data['country']
  Watir::Wait.until{ @browser.select(:id => 'region').options.count >= 50 } 
  @browser.select_list( :id, 'region').select data['state_name']
  Watir::Wait.until{ @browser.select(:id => 'city').options.count >= 5 } 

  @browser.select_list( :id, 'city').select data['city']
  @browser.text_field( :name, 'address').set data['address']
  @browser.text_field( :name, 'zip').set data['zip']
  @browser.text_field( :name, 'phone').set data['phone']
  @browser.text_field( :name, 'fax').set data['fax']

  category = data['category']
  puts category
  @browser.execute_script( 'document.getElementsByName("category1")[0].value="' + category +'";') 
  puts "category set" 

  data[ 'payment_methods' ].each{ | method |
      @browser.checkbox( :id => /#{method}/ ).clear
    }
  sleep(1)

  data[ 'payment_methods' ].each{ | method |
      @browser.checkbox( :id => /#{method}/ ).set
    }

  @browser.text_field( :name, 'url').set data['url']
  @browser.text_field( :name, 'facebook').set data['facebook']
  @browser.text_field( :name, 'twitter_name').set data['twitter_name']
  @browser.text_field( :name, 'desc').set data['desc']
  @browser.text_field( :name, 'brands').set data['brands']
  @browser.text_field( :name, 'products').set data['products']
  @browser.text_field( :name, 'services').set data['services']

  @browser.button( :value => /Update Business/).click

  @browser.link(:text => 'instantly live on iBegin').wait_until_present
  @browser.link(:text => 'instantly live on iBegin').click
  listing_url =  @browser.url
  self.save_account("Ibegin", { :status => "Listing updated successfully!", :listing_url => listing_url})

  sync_images(data)

  true
end 

def remove_existing_images(data)
  if @browser.link(:text => "Delete Photo").exists?
    @browser.link(:text => "Delete Photo").click
    @browser.alert.ok
    Watir::Wait.until{ @browser.text.include? "Photo was successfully deleted" }

    remove_existing_images
  end 
end 

def upload_images(data)
  images.each do |p| 
    f = File.join("#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images", p)
    puts "file #{f}"
    @browser.link(:text => /Upload a Photo/).click 


    @browser.file_field(:name => 'userfile').value= f
    @browser.text_field(:name => 'caption').set data['business_name']
    @browser.form(:name => "form_avatar").button.click

    sleep 1 # simply to prevent raising any red flags. 
  end 
end 

def sync_images(data)
  @browser.goto "http://www.ibegin.com/business-center/"
  @browser.link(:text => "Add/Edit Photos").click

  remove_existing_images(data)
  upload_images(data)
end 

@heap = JSON.parse( data['heap'] ) 

unless @heap['signed_up'] 
  @heap['signed_up'] = sign_up(data)
  self.save_account("Ibegin", {"heap" => @heap.to_json})
end 

if @heap['signed_up'] && !@heap['listing_created']
  @heap['listing_created']  = create_listing(data) 
  self.save_account("Ibegin", {"heap" => @heap.to_json})
end 

if @heap['listing_created']
  @heap['listing_updated']  = update_listing(data) 
  self.save_account("Ibegin", {"heap" => @heap.to_json})
end 

if (!@heap['signed_up'] || !@heap['listing_created'] || !@heap['listing_updated']) && @heap['phone_verified']
  self.start("Ibegin/UpdateListing", 1440)
end 

self.success
