@browser.goto("http://www.merchantcircle.com/signup?utm_medium=signup")
@browser.text_field(:id, "name").set data['name']
@browser.text_field(:id, "telephone").set data['phone']
@browser.text_field(:id, "address").set data['address']
@browser.text_field(:id, "zip").set data['zip']
@browser.text_field(:id, "fname").set data['first_name']
@browser.text_field(:id, "lname").set data['last_name']
@browser.text_field(:id, "email").set data['email']
@browser.text_field(:id, "email2").set data['email']
@browser.text_field(:id, "password").set data['password']
@browser.checkbox(:id, "offers").click
@browser.checkbox(:id, "tos_agree").click
@browser.button(:value, "Submit").click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Merchantcircle'


#@browser.button(:value, "Finished").click
@browser.link(:text, "No, Thanks").click
@browser.link(:text, "No, thanks").click
@browser.link(:text, "Continue").click
@browser.link(:href, "http://www.merchantcircle.com/merchant/edit").click
@browser.text_field( :id, "description").when_present.set data[ 'description' ]
@browser.text_field( :id, "fax").set data[ 'fax' ]
@browser.text_field( :id, "tollfree").set data[ 'tollfree' ]
@browser.text_field( :id, "url").set data[ 'website' ]
@browser.text_field( :id, "tags").set data[ 'keywords']
@browser.button( :name, "updateListing").click

if @chained
  self.start("Merchantcircle/Verify")
end

true
