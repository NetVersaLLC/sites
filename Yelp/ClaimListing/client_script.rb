@browser = Watir::Browser.new :firefox

at_exit {
    unless @browser.nil?
        @browser.close
    end
}

def claim_listing( data )
    retried = false
    @browser.text_field(:name, 'first_name').set data['first_name']
    @browser.text_field(:name, 'last_name').set data['last_name']
    @browser.text_field(:name, 'email').set data['email']
    @browser.text_field(:name, 'password').set data['password']
    @browser.button(:value, 'submit').click
    @browser.div(:id, 'signup_confirm').wait_until_present # Needed
    #code = @browser.element(:xpath, '//*[@id="signup_confirm"]/form/ol/li[2]/strong').to_s
    @browser.button(:value, 'submit').click
    @browser.span(:id, 'call_code').wait_until_present
    code = @browser.span(:id, 'call_code').text
    puts "Code: " + code
    PhoneVerify.send_code("yelp", code)
    begin
        @browser.span(:id, 'call_code').wait_while_present(300)
    rescue => e
        puts (e.inspect)
        sleep 60
    end
    if @browser.text.include? "We're sorry but we were unable to call your business at this time."
        throw "Call could not go through."
    elsif @browser.text.include? "Your confirmation call could not be completed, the wrong code was entered."
        throw "Wrong Code!"
        #PhoneVerify.wrong_code
    elsif @browser.span(:text, /Call Me Again/).exists?
        raise "Something went wrong!"
    else
        puts "Success!"
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

begin
    if @browser.text.include? "Business matches for"
        @browser.lis(:class => /business-result/).each do |result|
            item = result.li(:class => 'name-col')
            puts("Comparing business..'#{data['name']}' with listing..'#{item.h3.text}'")
            if item.h3.text == data['name']
                if not result.li(:class => 'buttons-col').link(:class => 'already-unlocked').exists?                
                    puts "Listing found! Claiming..."
                    result.li(:class => 'buttons-col').button(:value => 'submit').click
                    claim_listing( data )
                    self.save_account("Yelp", { :email => data['email'], :password => data['password']})
                    break
                else
                    puts "Business already claimed!"
                    break
                end
            end
        end
    end
rescue StandardError => e
    puts "Something somewhere messed up."
    throw e.inspect
end
true