@browser = Watir::Browser.new :firefox

at_exit do
    unless @browser.nil?
        @browser.close
    end
end

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
        @browser.lis(:class => /business-result/).each do |result|
            item = result.li(:class => 'name-col')
            puts("Comparing business..'#{data['name']}' with listing..'#{item.h3.text}'")
            if item.h3.text == data['name']
                if not result.li(:class => 'buttons-col').link(:class => 'already-unlocked').exists?                
                    businessListed = true
                    break
                else
                    throw "Business already claimed!"
                end
            end
        end
    end
rescue StandardError => e
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
        data['hours'].each do |day,time|
            unless data['hours'][day].nil?
                day = day[0..2].capitalize
                puts "Day: " + day
                @browser.select_list(:class, 'weekday').select day
                if time.first =~ /0\d:\d\d/
                    open = time.first.split("")
                    open.delete_at(0)
                    open = open.join
                else
                    open = time.first
                end
                if time.last =~ /0\d:\d\d/
                    close = time.last.split("")
                    close.delete_at(0)
                    close = close.join
                else
                    close = time.last
                end
                puts "Open: " + open
                puts "Close: " + close
                @browser.select_list(:class, 'hours-start').select open
                @browser.select_list(:class, 'hours-end').select close
                @browser.span(:text, 'Add Hours').click
            end
        end
    rescue => e
        puts e.inspect
        puts "We came, we tried, we failed. Moving on."
    end
    
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
        puts("Problem selecting category on Yelp. Attempting to recover.")
        select_lists = @browser.select_lists(:name, 'category')
        if data['rootcat'] == ""

            if data['parent'] == ""
                @browser.select_lists[4].select data['category']
            else
                @browser.select_lists[4].select data['parent']
                sleep 4
                @browser.select_lists[5].select data['category']
            end
        else
            @browser.select_lists[4].select data['rootcat']
            sleep 4
            @browser.select_lists[5].select data['parent']
            sleep 4
            @browser.select_lists[6].select data['category']
        end 
    end

    @browser.text_field(:name => 'email').set data['email']
    @browser.button(:text => 'Add').click
    
    sleep 2
    Watir::Wait.until { @browser.text.include? "Check your Email to Submit Your Business to Yelp" }
    
    if @browser.text.include? "Check your Email to Submit Your Business to Yelp"
            self.save_account("Yelp", {:email => data['email']})
	    if @chained
		  self.start("Yelp/Verify")
	    end
	true
    else
        throw "Error while adding business"
    end
else
    puts "Business match found! Chaining to claim..."
    if @chained
        self.start("Yelp/Notify")
    end
    true
end

