# Developer's Notes
# Uncertain how long it takes the business to appear

# Browser Code
@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

# Classes
class BusinessNotFound < StandardError
end

# Methods

# This method enters the business' local phone number
# and searches for them. If found, it'll continue to
# update the listing, otherwise report back that
# it was not found and try again in 24 hours, on the
# thought that the listing hasn't appeared yet.

def search_business(data)
  retries ||= 3
  @browser.goto('http://www.ziplocal.com/olc/lookup.faces')
  @browser.text_field(:id, 'lookupForm:tel').set data['phone']
  @browser.link(:id, 'lookupForm:submit').click
  # Iterate through all links on the page to be safe
  links = @browser.links
  max = links.length
  count = 0
  links.each do |link|
    link_text = link.text.gsub(/[^0-9a-z]/i, '').downcase
    puts "Link: " + link_text
    business = data['business'].gsub(/[^0-9a-z]/i, '').downcase
    puts "Business: " + business
    if link_text == business
      @listing = link.href
      @listing.sub!('listing.faces', 'edit_listing.faces')
    else
      count += 1
    end
  end
  if count == max
    raise BusinessNotFound
  end
rescue BusinessNotFound
  if @chained
    self.start("Ziplocal/UpdateListing", 1440)
  end
  self.failure("Business not found, trying again in 24 hours")

rescue => e
  retry unless (retries -= 1).zero?
  self.failure(e)
  return false
else
  puts "Business found."
  return true
end

# This method updates the listing. It does not update categories.
# Some listings already have nicer categories than we can provide,
# and for that reason we leave them alone. Also, categories are finicky.
# CreateListing should set correct categories.

def update_business(data)
  retries ||= 3
  @browser.goto(@listing)
  # Add business information
  @browser.text_field( :id, 'listingForm:disp').when_present.set data[ 'business' ]
  @browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
  @browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
  @browser.text_field( :id, 'listingForm:_id154').set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
  @browser.text_field( :id, 'listingForm:_id159').set data[ 'email' ]
  @browser.radio( :value, 'O').set
  @browser.text_field(:id, "listingForm:_id157").set data['prefix']
  # Add Contact information
  contact_fields = @browser.text_fields(:id => /listingForm:_id/, :type => 'text')
  contact_fields[0].set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
  contact_fields[2].set data['email']
  @browser.radio(:name => 'listingForm:contact_type', :value => 'O').click
  @browser.link(:id, /listingForm:_id/).click
  Watir::Wait.until { @browser.text.include? 'Thank you for updating our directory.' }
rescue => e
  retry unless (retries -= 1).zero?
  self.failure(e)
else
  self.success("Business updated successfully.")
end

# Controller
if search_business(data) == true
  update_business(data)
end
