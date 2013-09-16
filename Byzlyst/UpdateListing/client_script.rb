# Global Retry Count, affects all rescues
@retries = 5

# Methods
def update_details( data )
	@browser.img(:src, /a3.png/).when_present.click
	@browser.link(:class => "button green", :text => "Edit").click
	@browser.text_field(:id, "form_title").when_present.set data['business']
	@browser.text_field(:id, "form_tagline").set data['tagline']
	@browser.textarea(:id, "form_short").set data['short_desc']
	@browser.textarea(:id, "form_description").set data['full_desc']
	@browser.text_field(:id, "form_tags").set data['keywords']
rescue => e
  unless @retries == 0
    puts "Error caught while updating listing details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while updating listing details could not be resolved. Error: #{e.inspect}"
  end
end

def update_additional_details( data )
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
	Watir::Wait.until { @browser.text.include? "Congratulations, your listing has been saved successfully." }
rescue => e
  unless @retries == 0
    puts "Error caught while updating additional details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while updating additional details could not be resolved. Error: #{e.inspect}"
  end
end

def update_category( data )
  @browser.selectlist(:name, "CatSel[0]").option(:text, /#{data['category']}/).select
rescue => e
  unless @retries == 0
    puts "Error caught while updating categories: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while updating categories could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
sign_in( data )
update_details( data )
update_additional_details( data )
#update_category( data )