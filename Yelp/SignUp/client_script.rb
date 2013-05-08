retries = 3
begin
    @browser.goto("https://biz.yelp.com")
    @browser.a(:text => 'Create your free account now').click
    @browser.text_field(:id => 'business-search-query').set data['name']
    @browser.text_field(:id => 'business-search-location').set "#{data['city']}, #{data['state']}"
    sleep(1)
    @browser.button(:type => 'submit').click

    sleep 2
    Watir::Wait.until { @browser.link(:text => "Add your business to Yelp").exists? }
rescue Exception => e
    puts(e.inspect)
    if retries > 0
        puts("There was a problem searching for your business. Retrying...")
        sleep 3
        retries -= 1
        retry
    else
        raise StandardError.new "There was a problem searching for your business and after 3 tries we are giving up."
    end
end

businessListed = false

begin
    if @browser.text.include? "Business matches for"
        @browser.lis(:class => 'name-col').each do |item|
            puts("Comparing business..'#{data['name']}' with listing..'#{item.h3.text}'")
            if item.h3.text == data['name']                
                businessListed = true
            end
        end
    end
rescue Exception => e
    puts(e.inspect)
    sleep 2
    puts("Attemping to recover..")
    sleep 2
end


sleep(1)
if not businessListed
    @browser.a(:text => "Add your business to Yelp").click
    sleep 2
    @browser.text_field(:id => 'biz_name').when_present.set data['name']
    @browser.text_field(:id => 'biz_address1').set data['address']
    @browser.text_field(:id => 'biz_address2').set data['address2']
    @browser.text_field(:id => 'biz_city').set data['city']
    @browser.text_field(:id => 'biz_state').set data['state']
    @browser.text_field(:id => 'biz_zipcode').set data['zip']
    @browser.text_field(:id => 'biz_phone').set data['phone']
    @browser.text_field(:id => 'biz_website').set data['website']
    
    begin
        if data['rootcat'] == ""

            if data['parent'] == ""
                @browser.select_list(:index, 4).select data['category']
            else
                @browser.select_list(:index, 4).select data['parent']
                sleep 4
                @browser.select_list(:index, 5).select data['category']
            end
        else
            @browser.select_list(:index, 4).select data['rootcat']
            sleep 4
            @browser.select_list(:index, 5).select data['parent']
            sleep 4
            @browser.select_list(:index, 6).select data['category']
        end

    rescue Exception => e
        puts(e.inspect)
        puts("Problem selecting category on Yelp. Attempting to recover. Category will need to be set later.")
        @browser.select_list(:index, 4).select "Active Life"
           sleep 4
        @browser.select_list(:index, 5).select "Golf"
    end

    @browser.text_field(:name => 'email').set data['email']
    @browser.button(:text => 'Add').click
    
    sleep 2
    Watir::Wait.until { @browser.text.include? "Check your Email to Submit Your Business to Yelp" }
    
    if @browser.text.include? "Check your Email to Submit Your Business to Yelp"
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

