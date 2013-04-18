@browser.goto("https://biz.yelp.com")
@browser.a(:text => 'Create your free account now').click
@browser.text_field(:id => 'business-search-query').set data['name']
@browser.text_field(:id => 'business-search-location').set "#{data['city']}, #{data['state']}"
sleep(1)
@browser.button(:type => 'submit').click
Watir::Wait::until do
    if @browser.text.include? "Sorry, there were no matches" or @browser.text.include? "Category:"
        true
    else
        false
    end
end
sleep(1)
if @browser.text.include? "Sorry, there were no matches"
    @browser.a(:text => "Add your business to Yelp").click
    @browser.text_field(:id => 'biz_name').set data['name']
    @browser.text_field(:id => 'biz_address1').set data['address']
    @browser.text_field(:id => 'biz_address2').set data['address2']
    @browser.text_field(:id => 'biz_city').set data['city']
    @browser.text_field(:id => 'biz_state').set data['state']
    @browser.text_field(:id => 'biz_zipcode').set data['zip']
    @browser.text_field(:id => 'biz_phone').set data['phone']
    @browser.text_field(:id => 'biz_website').set data['website']
    @browser.select_list(:index, 4).select data['cat1']
    sleep 1
    @browser.select_list(:index, 5).select data['cat2']
    @browser.text_field(:name => 'email').set data['email']
    @browser.button(:text => 'Add').click
    Watir::Wait::until do
        @browser.text.include? "Your Business Is Almost On Yelp"
    end
    if @browser.text.include? "Your Business Is Almost On Yelp"
        RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'model' => 'Yelp'
	if @chained
		self.start("Yelp/Verify")
	end
	true
    else
        puts "Somekinda error"
    end
else
    puts "Not yet"
end

