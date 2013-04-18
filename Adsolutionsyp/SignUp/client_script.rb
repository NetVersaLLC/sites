@browser.goto("https://adsolutions.yp.com/listings/basic")

puts(data['password'])

@browser.text_field(:id => 'BusinessPhoneNumber').set data['phone']
@browser.text_field(:id => 'BusinessName').set data['business']
@browser.text_field(:id => 'BusinessOwnerFirstName').set data['fname']
@browser.text_field(:id => 'BusinessOwnerLastName').set data['lname']
@browser.text_field(:id => 'Email').set data['email']

@browser.text_field(:id => 'txtCategories').set data['category']
sleep 1
@browser.link(:xpath => "/html/body/ul/li[1]/a").when_present.click
@browser.text_field(:id => 'BusinessAddress_Address1').set data['address']
@browser.text_field(:id => 'BusinessAddress_City').set data['city']
@browser.select_list(:id => 'BusinessAddress_State').select data['state']
@browser.text_field(:id => 'BusinessAddress_Zipcode').set data['zip']
@browser.text_field(:id => 'BusinessYear').set data['founded']
@browser.image(:alt => 'continue').click
sleep 3

@browser.text_field(:id => /BusinessWebsites/i).when_present.set data['website']
data['payments'].each do |pay|
	@browser.checkbox(:id => pay).click
end
enter_captcha
@browser.text_field(:id => 'RepeatEmail').when_present.set data['email']
@browser.text_field(:id => 'Password').set data['password']
@browser.text_field(:id => 'RepeatPassword').set data['password']
@browser.select_list(:id => 'SecurityQuestion').select "What is your mother's maiden name?"
@browser.text_field(:id => 'SecurityAnswer').set data['secret_answer']

@browser.checkbox(:id => 'TermsOfUse').click

@browser.button(:id => 'submitButton').click

sleep(5) #adding sleeps as it timesout after 30 seconds more often than usual. Just giving it some buffer time
Watir::Wait.until {@browser.text.include? "Your listing will not be displayed on YP.com until you have completed verification."}

@browser.link(:id => 'verifyLaterPhoneLink').click

sleep(5)
Watir::Wait.until {@browser.text.include? "Your Free Listing Details"}

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'account[secret_answer]' => data['secret_answer'], 'model' => 'Adsolutionsyp'

if @chained
	self.start("Adsolutionsyp/Verify")
end

true