url = 'https://foursquare.com/signup/join'
@browser.goto(url)
#@browser = Watir::browser.start("https://foursquare.com/search?q=saigon&near=columbia%2C+mo")
#@browser.text_field(:id, 'searchBox').set data['name']
#@browser.text_field(:id, "locationInput").set data['city']+', '+data['state']
#@browser.button( :id, 'searchButton').click
#@browser.a(:class, "p.translate > input.greenButton.translate").click
#@browser.a(:text, "Saigon Bistro").click
#@browser.a(:text, "Claim here").click
#@browser.a(:text, "Sign up for foursquare").click
#@browser.a(:text, "Sign up with Email").click
@browser.text_field(:id, "firstname").set data['first_name']
@browser.text_field(:id, "lastname").set data['last_name']
#@browser.text_field(:class, "#emailWrapper > span.input-holder > span.input-default").click
@browser.text_field(:id, "userEmail").set data['email']
@browser.text_field(:alt, "Password").set data['password']
@browser.text_field(:id, "userPhone").set data['phone']
@browser.text_field(:id, "userLocation").set data['city']
@browser.select_list(:class, "dateSelect month").select data['birth_month']
@browser.select_list(:class, "dateSelect day").select data['birth_day']
@browser.select_list(:class, "dateSelect year").select data['birth_year']
#@browser.file_field(:class, "F221050266022QSTXN5").set data.profile_image
@browser.file_field(:type => 'file').set data['logo']
@browser.button(:value, "Join").click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Foursquare'

Watir::Wait.until{@browser.text.include? "Now you can check in!"}

@browser.a(:id, "continueLink").click

Watir::Wait.until{@browser.text.include? "Welcome! Now let's find you some friends."}

@browser.link(:id => 'done').click

	if @chained
		self.start("Foursquare/Verify")
	end

true
