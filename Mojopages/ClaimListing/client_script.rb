eval(data['payload_framework'])
class ClaimBusiness < PayloadFramework
  def run
    area = data[:phone_area_code]
    prefix = data[:phone_prefix]
    suffix = data[:phone_suffix]
    @url = "http://mojopages.com/biz/find?areaCode=#{area}&exchange=#{prefix}&phoneNumber=#{suffix}"
    browser.goto(@url)
    register
    sleep 1
    if browser.text.include? "Another user with the same email address"
      login
    else
      wait_until { browser.text.include? 'Welcome' }
      save :email, :password
    end
    claim_business
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

  def claim_business
    browser.goto @url
    wait_until { browser.text.include? 'Is this your business?' }
    sleep 2
    click :claim_business
    # wait_until { browser.text.include? "By checking here, I agree" }
    # browser.execute_script "$j('[type=checkbox]').attr('checked',true);"
    # browser.execute_script "return confirm(this)"
    wait_until_present :terms_of_service
    check :terms_of_service
    click :continue
    # listing_id = browser.url.split('/').last
    # browser.goto "mojopages.com/business/confirm/#{listing_id}"
    # form_id = browser.form(:action, '/business/claim').id
    # browser.execute_script "document.getElementById('#{form_id}').submit();"
    already_claimed = 'This business has already been claimed.'
    raise already_claimed if browser.text.include? already_claimed
  end


  def select_category
    wait_until {
      @has_category = browser.text.include? 'Confirm your category'
      @no_category = browser.text.include? 'Choose your business category'
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
      :claim_business => 'a.button.positive',
      :terms_of_service => '#lightwindow_contents > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > input:nth-child(1)',
      :continue => '#lightwindow_contents > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > input:nth-child(1)',
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
      :category_select => "option[value='#{data[:category]}']"
    }
  end
end

ClaimBusiness.new('Mojopages',data,self).verify