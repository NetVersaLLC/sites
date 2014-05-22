@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

@browser.goto("http://www.merchantcircle.com/signup?utm_medium=signup")
@browser.text_field(:id, "name").set data['name']
@browser.text_field(:id, "telephone").set data['phone']
@browser.text_field(:id, "address").set data['address']
@browser.text_field(:id, "zip").set data['zip']
@browser.select_list(:id,"levelone").select "Entertainment & Arts -->"
sleep 5
@browser.select_list(:id,"leveltwo").select "Entertainers"
@browser.button(:class,"btn").click
sleep 20
if @browser.radio(:value,'create').exists?
	@browser.radio(:value,'create').set
	sleep 5
    @browser.button(:xpath,'/html/body/div[3]/div/section/div[3]/button').click
	
end
sleep 15

@browser.text_field(:name, "user_name").set data['full_name']

@browser.text_field(:name, "user_email").set data['email']
@browser.text_field(:name, "user_email_confirmation").set data['email']
@browser.text_field(:name, "user_password").set data['password']
@browser.text_field(:name, "user_password_confirmation").set data['password']
@browser.checkbox(:name, "offers").clear
# puts "1234"
@browser.checkbox(:name,"tos_agree").set
@browser.button(:xpath,"/html/body/div[3]/div/section[2]/div[2]/button").click
puts "You are successfully listed."
# sleep 10
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Merchantcircle'
if @chained
  self.start("Merchantcircle/Verify")
end

true
# @browser.text_field(:id, "fname").set data['first_name']
# @browser.text_field(:id, "lname").set data['last_name']
# @browser.text_field(:id, "email").set data['email']
# @browser.text_field(:id, "email2").set data['email']
# @browser.text_field(:id, "password").set data['password']
# @browser.checkbox(:id, "offers").clear
# @browser.send_keys :tab
# @browser.send_keys :space
# # Wouldn't check for some reason
# #@browser.checkbox(:id, "tos_agree").set
# @browser.button(:value, "Claim This Business Listing").click

# RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Merchantcircle'


# #@browser.button(:value, "Finished").click
# @browser.link(:text, "No, Thanks").when_present.click
# @browser.link(:text, "No, thanks").when_present.click
# @browser.link(:text, "Continue").when_present.click
# @browser.link(:href, "http://www.merchantcircle.com/merchant/edit").click
# @browser.text_field( :id, "description").when_present.set data[ 'description' ]
# sleep 9999999
# @browser.text_field( :id, "tollfree").set data[ 'tollfree' ]
# @browser.text_field( :id, "url").set data[ 'website' ]
# @browser.text_field( :id, "tags").set data[ 'keywords']
# @browser.button( :name, "updateListing").click

# Watir::Wait.until { @browser.text.include? "Your business listing has been updated." }


