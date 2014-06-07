# Main Script start from here
# Launch url
@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end
def login(data)
  if !data['email'].empty? and !data['password'].empty?
    @browser.text_field(:name=>'user[email]').set data['email']
    @browser.text_field(:name=>'user[password]').set data['password']
    @browser.button(:name=>'commit').click
  else
    raise StandardError.new("You must provide both a username AND password for login!")
  end 
end

def verify_updation(url)
  if @browser.text.include? 'Listing was successfully updated.'
      puts "Listing updated successfully."
        self.save_account("Citisquare",{:listing_url=>url})
        true
      
  else
    raise "Some problem in listing of your business."
      false
  end
end


url = 'http://citysquares.com/user/login'
@browser.goto url
# 30.times{break if @browser.status == "Done"; sleep 1}

login data

@browser.wait()
@browser.link(:class=>'btn-login').click
# sleep 20
if @browser.text.include? "You haven't listed any businesses yet."
  # puts "3456"
  @browser.link(:xpath=>'/html/body/div[2]/div/div[2]/div/div/div[2]/div[2]/p/a[2]').click
  @browser.wait()
  url = @browser.url
  @browser.text_field(:id=>'listing_name').set data['business']
  @browser.select_list(:id=>'listing_category_id').select data['category']
  
  @browser.text_field(:id=>'listing_address').set data['address']
   @browser.select_list(:id=>'states_select').select data['state']
   sleep 10
  @browser.select_list(:id=>'cities_select').select data['city']
  @browser.text_field(:id=>'listing_postal_code').set data['zip']
  @browser.checkbox(:id=>'listing_terms').set
  sleep 10
  @browser.button(:class=>'btn-info').click
  verify_updation url
else

     if @browser.text.include? 'My Businesses'
	# @browser.link(:xpath=>'/html/body/div[2]/div/div[2]/div/div[2]/div[2]/div/div/div/div[2]/div/span[2]/a').click
        @browser.link(:text=>data['business']).click
        @browser.link(:text=>'Manage').click
        sleep 10
        url = @browser.url
          @browser.select_list(:id=>'listing_category_id').select data['category']
	@browser.text_field(:id=>'listing_phone_numbers_attributes_0_formatted').set data['phone']
	@browser.textarea(:id=>'listing_description').set data['description']
	@browser.button(:class=>'btn btn btn-info').click
	30.times{break if @browser.status == "Done"; sleep 1}

	verify_updation url
     end
end
