# Global Retry Count, affects all rescues
@retries = 5

# Methods
def add_listing_details( data )
	@browser.img(:src, /a5.png/).when_present.click
	@browser.link(:onclick, /1/).when_present.click
	@browser.text_field(:id, "form_title").when_present.set data['business']
	@browser.text_field(:id, "form_tagline").set data['tagline']
	@browser.textarea(:id, "form_short").set data['short_desc']
	@browser.textarea(:id, "form_description").set data['full_desc']
	@browser.text_field(:id, "form_tags").set data['keywords']
rescue => e
  unless @retries == 0
    puts "Error caught while adding listing details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while adding listing details could not be resolved. Error: #{e.inspect}"
  end
end

def add_additional_details
	@browser.text_field(:id, "form_email").set data['email']
	@browser.text_field(:id, "form_url").set data['website']
	@browser.selectlist(:name, "form[country]").option(:text, /United States/).select
	@browser.text_field(:name "custom[0][value]").set data['website']
	@browser.text_field(:name, "custom[1][value]").set data['address']
	@browser.text_field(:name, "custom[2][value]").set data['city']
	@browser.text_field(:name, "custom[3][value]").set data['state']
	@browser.text_field(:name, "custom[4][value]").set data['zip']
	@browser.checkbox(:id, "agreeTC").set
  @browser.button(:id, "submitMe").click
  Watir::Wait.until { @browser.text.include? "Listing Confirmation" }
  @browser.button(:value, "Continue").click
rescue => e
  unless @retries == 0
    puts "Error caught while adding additional details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while adding additional details could not be resolved. Error: #{e.inspect}"
  end
end

def add_category( data )
  @browser.selectlist(:name, "CatSel[0]").option(:text, /#{data['category']}/).select
rescue => e
  unless @retries == 0
    puts "Error caught while adding categories: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while adding categories could not be resolved. Error: #{e.inspect}"
  end
end


# Main Controller
sign_in( data ) # Signs in
add_listing_details( data ) # Waits for account page, adds listing name, desc, and keywords
add_category( data ) # Adds the category
add_additional_details( data ) # Adds email, website, location information, submits
#add_category( data )
true


# bundle exec rails g model Byzlyst business_id:integer:index secrets:text force_update:datetime email:string secret_answer:string username:string

# rails generate model ByzlystCategory parent_id:integer:index name:string

# add_column :byzlysts, :byzlyst_category_id, :integer