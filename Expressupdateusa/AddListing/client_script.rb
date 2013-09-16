#Global Retry Count, affects all rescues
@retries = 8

# Methods
def initial_signup( data )
  @browser.goto("http://www.expressupdate.com/place_submissions/new")
  @browser.text_field(:id, "place_submission_name").when_present.set data['business_name']
  @browser.text_field(:id, "place_submission_street").set data['business_address']
  @browser.text_field(:id, "place_submission_city").set data['business_city']
  @browser.selectlist(:id, "place_submission_state").select data['business_state']
  @browser.text_field(:id, "place_submission_zip").set data[ 'business_zip' ]
  @browser.text_field(:id, "place_submission_phone").set data['business_phone']
rescue => e
  unless @retries == 0
    puts "Error caught during initial signup. Error: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error encountered during initial signup could not be resolved. Error: #{e.inspect}"
  end
end

def add_category( data )
  @browser.link(:id, "primary_sic_code_name").click
  @browser.text_field(:class, "ac-tf span4 ui-autocomplete-input").when_present.set data['business_category']
  @browser.link(:text, "#{data['business_category']}").when_present.click
rescue => e
  unless @retries == 0
    puts "Error caught while adding the category. Error: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error encountered while adding the category could not be resolved. Error: #{e.inspect}"
  end
end 

def add_contact( data )
  @browser.text_field(:id, "place_submission_first_name").set data['business_firstname']
  @browser.text_field(:id, "place_submission_last_name").set data['business_lastname']
  @browser.text_field(:id, "place_submission_email").set data['business_email']
  @browser.button(:class => "btn btn-submit btn-green", :text => "SUBMIT").click
rescue => e
  unless @retries == 0
    puts "Error caught while adding contact information. Error: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error encountered while adding contact information could not be resolved. Error: #{e.inspect}"
  end
end 

# Main Controller
sign_in( data ) # Signs in prior to adding listing
initial_signup( data ) # Adds basic info
add_category( data ) # Adds category
add_contact( data ) # Adds contact info, submits form
Watir::Wait.until { @browser.text.include? "Thanks for your submission! We will send you an email as soon as your place has been approved." }
if @chained == true
  self.start("")
end
true