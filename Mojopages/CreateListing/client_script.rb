eval(data['payload_framework'])
class CreateBusiness < PayloadFramework
  def run
    browser.goto 'mojopages.com'
    register
    sleep 1
    if browser.text.include? "Another user with the same email address"
      login
    else
      wait_until { browser.text.include? 'Welcome' rescue nil }
      save :email, :password
    end
    create_business
    select_category
  end

  def verify
    wait_until { browser.text.include? 'Please verify' rescue nil }
    submit
    true
  end

  def register
    context(:registration) {
      click :sign_up
      wait_until_present :email
      enter :first_name
      enter :last_name
      enter :email
      enter :password
      enter :password_confirmation, data[:password]
      enter :zip
      click :"#{data[:gender]}"
      submit
    }
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

  def create_business
    browser.goto 'mojopages.com/biz/add'
    enter :company_name
    enter :address
    enter :city
    enter :zip
    enter :phone
    enter :website
    enter :tagline, data[:tagline].ljust(100)
    enter :description, data[:description].ljust(500)
    submit
  end

  def select_category
    wait_until {
      @has_category = browser.text.include? 'Confirm your category' rescue nil
      @no_category = browser.text.include? 'Choose your business category' rescue nil
      @has_category or @no_category
    }
    context(:category) {
      click :continue if @has_category
      if @no_category
        until found_category ||= false
          case (tries ||= 0)
          when 0, 1
            category = data[:category]
          when 2, 3
            category = data[:category].split(' ').first
          when 4, 5
            category = data[:category].split(' ').last
          when 6
            raise "Could not find category '#{data[:category]}'."
          end
          tries += 1
          enter :category, category
          click :find_category
          if exists? :category_select
            click :category_select
            found_category = true
          end
        end
      end
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
      :tagline => '#businessDescription',
      :description => '#businessMetaDescription',
      :submit => '.bizCenterButton'
    }

    @elements[:registration] = {
      :sign_up => 'a:contains("Sign Up")',
      :first_name => '#firstName',
      :last_name => '#lastName',
      :email => '#email',
      :password => '#password',
      :password_confirmation => '#confirmPassword',
      :zip => '#postalCode',
      :male => '#Male',
      :female => '#Female',
      :submit => '#proceed'
    }

    @elements[:login] = {
      :email => '[name=username]',
      :password => '[name=password]',
      :submit => '[value=Login]'
    }

    @elements[:category] = {
      :continue => 'a.button.positive',
      :category => '[name=category]',
      :find_category => '[value="Find Category"]',
      :category_select => "[type=radio][value='#{data[:category]}']"
    }
  end
end

CreateBusiness.new('Mojopages',data,self).verify