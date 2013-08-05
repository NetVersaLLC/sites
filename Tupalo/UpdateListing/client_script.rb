#Update the business listing
url="http://tupalo.com/en/accounts/sign_in"
@browser.goto(url)

sleep 2
Watir::Wait::until {@browser.text.include? "Login"}


@browser.text_field(:id => "account_email").set data ['email']
@browser.text_field(:id => "account_password").set data['password']
@browser.button(:id => "spot_submit").click

sleep 2
Watir::Wait::until {@browser.text.include? "My Favorites"}#Login successfull

@browser.goto("http://tupalo.com/en/user/settings/profile")

sleep 5
Watir::Wait::until {@browser.text.include? "Account Settings"}#At the profile 

@browser.text_field(:id => "user_first_name").set data['first_name']
@browser.text_field(:id => "user_last_name").set data['last_name']
@browser.button(:name => "commit").click 

sleep 2
Watir::Wait::until {@browser.text.include? "Account Settings"}#At the profile 

@browser.goto("http://tupalo.com/en/b/dashboard")
sleep 2
Watir::Wait::until {@browser.text.include? "Statistics per month"}#At the Dashboard

@browser.a(:text => "Edit Spot").click
sleep 2
Watir::Wait::until {@browser.text.include? "Basic"}#At the profile editing page

@browser.text_field(:id => "spot_name").set data['business']
@browser.select_list.option(:text => data['category1']).select#Select the category from the drop down list.
sleep 2
if @browser.select_list(:id => "sublevel_category")	
	@browser.select_list(:id => "sublevel_category").select data ['category2']#Select the sub category if req.
end
@browser.text_field(:id => "spot_street").set data['address']#Enter the Business address
@browser.text_field(:id => "spot_phone").set data['phone']#Local phone number
@browser.text_field(:id => "spot_website").set data['website']#Set web site
@browser.text_field(:id => 'spot_city_and_country').clear
@browser.text_field(:id => 'spot_city_and_country').fire_event("onclick")
@browser.text_field(:id => 'spot_city_and_country').send_keys data['citystatecountry']#Select the city
@browser.button(:name => /commit/).click
sleep 2
Watir::Wait::until {@browser.text.include? "Basic"}#At the profile editing page

true