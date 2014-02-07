@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def upload_images(data)
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

@browser.goto 'http://www.city-data.com/profiles/add'


@browser.text_field(:name => 'name').set data['business']
@browser.text_field(:name => 'addr1').set data['address1']
@browser.text_field(:name => 'addr2').set data['address2']
@browser.text_field(:name => 'city').set data['city']
@browser.select_list(:name => 'state').select data['state']
@browser.text_field(:name => 'zip').set data['zip']
@browser.text_field(:name => 'phone').set data['phone']
@browser.text_field(:name => 'fax').set data['fax']
@browser.text_field(:id => 'email').set data['email']
@browser.text_field(:name => 'work_hours').set data['hours']
@browser.text_field(:name => 'year_established').set data['founded']
@browser.select_list(:name => 'cc_accept').select data['ccaccepted']
#@browser.select_list(:name => 'empl_num').select data['employees']
@browser.text_field(:id => 'pass').set data['password']
@browser.text_field(:name => 'rep').set data['password']
#cats
@browser.select_list(:name => 'cat').select data['category']

description = data['description']
if description.length < 349
	until description.length >= 350
		description << " "
	end
end

@browser.textarea(:name => 'descr').set description#data['description']
@browser.checkbox(:name => 'agree').set

@browser.button(:value => 'Add profile').click

sleep 4

Watir::Wait.until {
	@browser.text.include? "Thank you, your profile has been successfully added! It is now live on our site"
}

listing_url = @browser.link(:text=>/here/).href

@browser.goto "http://www.city-data.com/profiles/account"
upload_images(data)

self.save_account("Citydata", {:email => data['email'], :password => data['password'], :listing_url=>listing_url, :status => "Listing created successfully!"})

true
