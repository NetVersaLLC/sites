# Global Retry Count
@retries = 5

# Methods
def add_business_details( data )
	@browser.goto("http://www.brownbook.net/business/add/")
	@browser.text_field(:id, "business_name").when_present.set data['business']
	@browser.textarea(:id, "business_address").set "#{data['address']}, #{data['address2']}"
	@browser.text_field(:id, "business_postcode").set data['zip']
	@browser.select_list(:id, "business_country").select "United States"
	@browser.text_field(:id, "business_phone").set data['local_phone']
	@browser.text_field(:id, "business_mobile").set data['mobile_phone']
	@browser.text_field(:id, "business_fax").set data['fax']
	@browser.text_field(:id, "business_email").set data['email']
	@browser.text_field(:id, "business_website").set data['website']
	@browser.text_field(:id, "business_blog").set "" # Not yet provided/supported by our client
	@browser.text_field(:id, "business_twitter").set "" # Not yet implemented fully by our client
	@browser.text_field(:id, "business_voip").set "" # Not yet provided/supported by our client
	@browser.text_field(:id, "business_im").set "" # Not yet provided/supported by our client
rescue => e
  unless @retries == 0
    puts "Error caught while adding business details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding business details could not be resolved. Error: #{e.inspect}"
  end
end

def add_tags( data )
	@browser.textarea(:id, "tags").set data['tags']
	@browser.textarea(:id, "ltags").set "United Sates, #{data['state']}, #{data['city']}"
	@browser.button(:id, "submits").click
rescue => e
  unless @retries == 0
    puts "Error caught while adding tags: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error while adding tags could not be resolved. Error: #{e.inspect}"
  end
end

def sign_in( data )
  @browser.text_field(:id, "email").when_present.set data['email']
  @browser.text_field(:id, "password").set data['password']
  retry_captcha
  @browser.button(:id, "submits").click
end

def claim_listing( data )
  @browser.link(:text, /Claim this listing/).when_present.click
  @browser.text_field(:id, "user_name").when_present.set data['name']
  @browser.button(:id, "submits").click
  Watir::Wait.until { @browser.text.include? "Please confirm to proceed" }
  @browser.button(:id, "submits").click
  Watir::Wait.until { @browser.text.include? "Claim completed" }
end
# Main Controller
add_business_details( data )
add_tags( data )
sign_in( data )
claim_listing( data )
if @chained
    self.start("Brownbook/FinishListing")
end
true