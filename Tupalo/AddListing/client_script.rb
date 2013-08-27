#Login to the site

url="http://tupalo.com/en/accounts/sign_in"
@browser.goto(url)

30.times{ break if @browser.status == "Done"; sleep 1}

@browser.text_field(:id => "account_email").set data ['email']
@browser.text_field(:id => "account_password").set data['password']
@browser.button(:id => "spot_submit").click

30.times{ break if @browser.status == "Done"; sleep 1}

#Navigate to the add business url.
@browser.goto "http://tupalo.com/en/spots/new"

30.times{ break if @browser.status == "Done"; sleep 1}

@browser.text_field(:id => "spot_name").set data['business'] #Enter business name
@browser.select_list.option(:text => data['category1']).select#Select the category from the drop down list.
sleep 2
if @browser.select_list(:id => "sublevel_category")	
	@browser.select_list(:id => "sublevel_category").select data ['category2']#Select the sub category if req.
end

@browser.text_field(:id => "spot_street").set data['address']#Enter the Business address

@browser.text_field(:id => "spot_phone").set data['phone']#Local phone number
@browser.text_field(:id => "spot_website").set data['website']#Set web site

#Enter the working hours 
days = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']

days.each do |day|
	if data["#{day}"] == true		
		@browser.select_list(:name => "new_opening_hour_hours_begin").select data["#{day}_open"].gsub(/[AP]M/,"")
		closehours = data["#{day}_close"].gsub(/[AP]M/,"").split(":")[0].to_i
		if 	data["#{day}_close"] =~ /PM$/i #Convert closing hours to 24 hours format
			closehours = closehours + 12
		end
		closemin = data["#{day}_close"].gsub(/[AP]M/,"").split(":")[1]
		close = closehours.to_s + ":" + closemin		
		@browser.select_list(:name => "new_opening_hour_hours_end").select close
		@browser.span(:class => /button small/).click		
	end	
end

@browser.text_field(:id => 'spot_city_and_country').clear
@browser.text_field(:id => 'spot_city_and_country').fire_event("onclick")
#data=data['city']+", "+data['state'] #include this line to be more closer to the actual location.
@browser.text_field(:id => 'spot_city_and_country').send_keys data['city']#Select the city
sleep 10 #Let the list populate.
@browser.send_keys :tab
@browser.send_keys :enter

30.times{ break if @browser.status == "Done"; sleep 1}
if @chained
  self.start("Tupalo/ClaimListing")
end
true