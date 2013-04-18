@browser.goto("http://www.shopcity.com/map/mapnav_locations.cfm?")

@browser.link( :text => /#{data['country']}/).click
@browser.link( :text => /#{data['state']}/).click
@browser.link( :text => /#{data['cityState']}/).click	

@browser.img( :title => 'Add Your Business').when_present.click
@browser.link( :class => 'linkMarketButton').click
@browser.text_field( :id => 'subfolder_name').set data['siteName']

@browser.text_field( :name => 'email').set data['email']
@browser.text_field( :name => 'pw1').set data['password']

@browser.link( :title => 'GET STARTED!').click

sleep(5)
if @browser.text.include? "Congratulations!"
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Shopcity'

	if @chained
		self.start("Shopcity/AddListing")
	end
true
end
