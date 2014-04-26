eval(data['payload_framework'])
class UpdateListing < PayloadFramework
  def run
    login
    click :my_account
    wait_until { exists? :close_ad or exists? :dashboard }
    click :close_ad if exists? :close_ad
    click :edit_listing
    wait_until_present :edit_button
    click :edit_button
    update_listing
  end

  def verify
    true
  end

  def update_listing
    enter :company_name
    enter :address
    enter :city
    enter :zip
    enter :phone
    enter :website
    enter :tagline, data[:tagline].ljust(110)
    enter :description, data[:description].ljust(510)
    submit
  end

  def login
    context(:login) {
      browser.goto 'mojopages.com/login'
      enter :email
      enter :password
      submit
      wait_until { browser.text.include? 'Welcome' rescue nil }
    }
  end

  def setup_elements
    @elements[:main] = {
      :company_name => '#name',
      :first_name => '[name="owner.firstName"]',
      :last_name => '[name="owner.lastName"]',
      :email => '[name="owner.email"]',
      :address => '[name="address.streetName"]',
      :city => '[name="address.city"]',
      :zip => '[name="address.postalCode"]',
      :phone => '#fullPhone',
      :website => '#url',
      :tagline => '#description',
      :description => '#businessMetaDescription',
      :edit_button => 'a:contains("Edit")',
      :edit_listing => 'a:contains("Edit Business Profile")',
      :close_ad => '[name=dontShowAgain]',
      :dashboard => '#dashboard_business_info',
      :my_account => 'span.my_account_span',
      :submit => 'button:contains("Submit")'
    }

    @elements[:login] = {
      :email => '[name=username]',
      :password => '[name=password]',
      :submit => '[value=Login]'
    }
  end
end

UpdateListing.new('Mojopages',data,self).verify