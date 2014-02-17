@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end
def sign_in(data) 
  @browser.goto "http://www.city-data.com/profiles/account"

  @browser.text_field(:name => 'login').set data['email']
  @browser.text_field(:name => 'pass').set data['pass']

  @browser.button(:value => 'Login').click
end 


def update(data) 

  @browser.button(:value => 'Edit profile').when_present.click

  @browser.text_field(:name => 'year_established').wait_until_present

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
  #@browser.select_list(:name => 'empl_num').select data['employees']
  #cats
  @browser.select_list(:name => 'cat').select data['category']

  description = data['description']
  if description.length < 349
    description = description + " " + description
  end

  @browser.textarea(:name => 'descr').set description

  @browser.button(:value => 'Save changes').click

  @browser.button(:value => 'Edit profile').wait_until_present

  # click home 

  #search for item 
  #
  # if stuff equals then click link, and get the url of the opened window. 


end 

def remove_existing_images
  if @browser.button(:value => "Del").exists? 
    @browser.button(:value => "Del").click 
    @browser.button(:value => "Delete").click 
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

    @browser.file_field(:name => 'photo').value= f
    @browser.text_field(:name => 'descr').set data["business"]
    @browser.button(:value => "Add photo").click 
    sleep 1 # tap the brake
  end 
end 

def sync_images(data)
  @browser.goto "http://www.city-data.com/profiles/account"

  remove_existing_images 
  upload_images(data)

end 

sign_in(data)
update(data)
sync_images(data)

self.save_account("Citydata", {:status => "Listing updated successfully!"})

true
