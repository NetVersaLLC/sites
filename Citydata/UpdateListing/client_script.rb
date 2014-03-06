@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def create_listing(data) 
  return true unless data['email'].to_s.empty? || data['pass'].to_s.empty? 

  @browser.goto 'http://www.city-data.com/profiles/add'
  @browser.text_field(:id => 'email').set data['new_email']
  @browser.checkbox(:name => 'agree').set
  @browser.text_field(:id => 'pass').set data['new_password']
  @browser.text_field(:name => 'rep').set data['new_password']

  set_common_fields(data)

  @browser.button(:value => 'Add profile').click

  sleep(30)

  #There allready is a company with this phone in the database.
  # There allready is a company with this email
  if @browser.text.include? "Thank you, your profile has been successfully added! It is now live on our site"
    listing_url = @browser.link(:text=>/here/).href
    self.save_account("Citydata", {:email => data['new_email'], :password => data['new_password'], :listing_url=>listing_url, :status => "Listing created successfully!"})
  elsif @browser.span(:text => /allready is a company/)
    raise 'listing already exists.  listing_url will need to be set manually and a password reset.'
  else 
    raise 'unexpected response creating listing' 
  end 

  true
end 

def update_listing(data) 
  sign_in(data)

  @browser.button(:value => 'Edit profile').click

  sleep(30)
  @browser.text_field(:name => 'year_established').wait_until_present

  set_common_fields(data)
  @browser.button(:value => 'Save changes').click

  sleep(30)
  @browser.button(:value => 'Edit profile').wait_until_present

  sync_images(data)

  self.save_account("Citydata", {:status => "Listing updated successfully!"})

  true
end 


def sign_in(data) 
  @browser.goto "http://www.city-data.com/profiles/account"

  @browser.text_field(:name => 'login').set data['email']
  @browser.text_field(:name => 'pass').set data['pass']

  @browser.button(:value => 'Login').click
  sleep(30)
end 

def set_common_fields(data) 
  @browser.text_field(:name => 'name').set data['business']
  @browser.text_field(:name => 'addr1').set data['address1']
  @browser.text_field(:name => 'addr2').set data['address2']
  @browser.text_field(:name => 'city').set data['city']
  @browser.select_list(:name => 'state').select data['state']
  @browser.text_field(:name => 'zip').set data['zip']
  @browser.text_field(:name => 'phone').set data['phone']
  @browser.text_field(:name => 'fax').set data['fax']
  @browser.text_field(:name => 'work_hours').set data['hours']
  @browser.text_field(:name => 'year_established').set data['founded']
  @browser.select_list(:name => 'cc_accept').select data['ccaccepted']
  @browser.select_list(:name => 'cat').select data['category']

  description = data['description']
  if description.length < 349
    description = description + " " + description
  end

  @browser.textarea(:name => 'descr').set description
end 

def update(data) 
  @browser.text_field(:name => 'year_established').wait_until_present
  set_common_fields(data)
  @browser.button(:value => 'Save changes').click
  sleep(30)
  @browser.button(:value => 'Edit profile').wait_until_present
end 

def remove_existing_images
  if @browser.button(:value => "Del").exists? 
    @browser.button(:value => "Del").click 
    sleep(5)
    @browser.button(:value => "Delete").click 
    sleep(10)
    remove_existing_images
  end 
end 

def upload_images(data)
  root_path = "#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images"
  return unless File.exist?(root_path)

  images.each do |p| 
    f = File.join("#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images", p)
    puts "file #{f}"
    @browser.button(:value => "Add photo").click 
    sleep(10)

    @browser.file_field(:name => 'photo').value= f
    @browser.text_field(:name => 'descr').set data["business"]
    @browser.button(:value => "Add photo").click 
    sleep 30 
  end 
end 

def sync_images(data)
  @browser.goto "http://www.city-data.com/profiles/account"
  sleep(30)

  remove_existing_images 
  upload_images(data)
end 

@heap = JSON.parse( data['heap'] ) 

if @heap[:listing_created]
  @heap[:listing_updated]  = update_listing(data) 
  self.save_account("Citydata", {"heap" => @heap.to_json})
else 
  @heap[:listing_created] = create_listing(data)        
  self.save_account("Citydata", {"heap" => @heap.to_json})
end 

unless @heap[:listing_created] && @heap[:listing_updated] 
  self.start("Citydata/UpdateListing", 1440)
end 

self.success
