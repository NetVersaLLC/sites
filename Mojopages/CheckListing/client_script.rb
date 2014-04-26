eval(data['payload_framework'])
class CheckListing < PayloadFramework
  def run
    browser.goto('http://mojopages.com/biz/signup')
    enter :phone_area_code
    enter :phone_prefix
    enter :phone_suffix
    submit
  end

  def verify
    wait_until {
      @found = browser.text.include? "Is this your business?"
      @not_found = browser.text.include? "We couldn't find your business"
      @found or @not_found
    }
    if @found
      puts "Business found. Claiming business..."
      chain 'ClaimListing'
    elsif @not_found
      puts "Business not found. Creating business..."
      chain 'CreateListing'
    end
    true
  end

  def setup_elements
    @elements = {}
    @elements[:main] = {
      :phone_area_code => '#areaCode',
      :phone_prefix => '[name=exchange]',
      :phone_suffix => '[name=phoneNumber]',
      :submit => '[value="Find My Business"]'
    }
  end
end

CheckListing.new('Mojopages',data,self).verify