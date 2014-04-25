eval(data['payload_framework'])
class SignUp < PayloadFramework

  def run
    setup_basic
    setup_business_details
    setup_business_hours
    setup_payment_methods
    enter_captcha
    login unless register
  end

  def verify
    wait_until_present :footer_title
    verified = browser.text.include? "Verify Listing"
    if verified
      save :email, :password, :secret_answer
      chain "Notify"
    end
    return verified
  end

  def setup_basic
    browser.goto "https://adsolutions.yp.com/listings/basic"
    enter :phone
    enter :company_name
    enter :contact_first_name
    enter :contact_last_name
    enter :email
    enter :category_list, data[:category][0..3]
    wait_until_present :category
    click :category
    context(:address) do
      enter :address
      enter :city
      select :state
      enter :zip
    end
    enter :year
    click :continue
    sleep 3
    search = "Please select the listing"
    details = "Business Contact Information"
    wait_until {
      sleep 3
      result = [search,details].map {|s| browser.text.include? s}
      result.first or result.last
    }
    click :use_search_result if browser.text.include? search
    wait_until_present :footer_title
    if browser.text.include? "city you entered"
      raise "FATAL ERROR: This customer's city does not match its zip!"
    elsif browser.text.include? "Oops! There was an error submitting"
      if (retries ||= 0) < 5
        retries += 1
        retry
      else
        raise "FATAL ERROR: Unknown error in #setup_basic" if retries >= 5
      end
    end
  end

  def setup_business_details
    context(:business_details) do
      wait_until_present :alternate_business_name
      enter :alternate_business_name
      enter :website
      enter :website_description
      select :phone_type, 'Mobile'
      enter :mobile_phone
      enter :alternate_email
    end
  rescue
    if browser.text.include? "Listing Already Managed"
      raise "FATAL ERROR: This listing has already been created!"
      # remember to modify to handle more gracefully later
    elsif browser.text.include? \
      "Sorry, the city you provided is not valid for this zipcode."
      raise "FATAL ERROR: Business city does not match business zip!"
    end
  end

  def setup_business_hours
    context(:business_hours) do
      unless browser.text.include? "Use same hours for each weekday"
        click :expand_weekdays
      end
      data[:days_open].each do |day|
        start_merid = data[:"#{day}:start_merid"].upcase
        end_merid = data[:"#{day}:end_merid"].upcase
        start_time = [data[:"#{day}:start_time"],start_merid].join(" ")
        end_time = [data[:"#{day}:end_time"],end_merid].join(" ")
        select :"#{day}:start_time", start_time
        select :"#{day}:end_time", end_time
      end
      data[:days_closed].each do |day|
        check :"#{day}:is_closed" # #Monday_row .closeCheck
      end
    end
  end

  def setup_payment_methods
    context(:payment_methods) do
      data[:payment_methods].each do |payment_method|
        check payment_method.to_sym
      end
    end
  end

  def enter_captcha
    context(:captcha) do
      solve {
        submit
        true if wait_until_present :verification rescue false
      }
    end
  end

  def register
    context(:registration) do 
      wait_until_present :email
      enter :email
      enter :password
      enter :password_confirmation, data[:password]
      select :secret_question, "What is your favorite pet's name?"
      enter :secret_answer
      click :terms_of_service
      submit
    end
    sleep 2
    already_registered = "This email address is already registered."
    not browser.text.include? already_registered
  end

  def login
    url = "https://adsolutions.yp.com/SSO/Login?fDestination=%2Flistings%2Fverify"
    browser.goto url
    context(:login) do
      enter :email # #Email
      enter :password # #Password
      submit # input[type=image]
    end
  end

  def setup_elements
    @elements ||= {}

    @elements[:main] ||= {
      :wrapper => '#Business!!!',
      :phone => 'PhoneNumber',
      :company_name => 'Name',
      :contact_first_name => 'OwnerFirstName',
      :contact_last_name => 'OwnerLastName',
      :email => '/#Email',
      :category_list => '/#txtCategories',
      :category => "/ul#ui-id-1 li a:contains('#{data[:category]}')",
      :year => 'Year',
      :continue => '/img[alt="continue"]',
      :search_results => '/#searchResultsDiv',
      :use_search_result => '/#selectLink',
      :footer_title => '/.footer-title'
    }

    @elements[:address] ||= {
      :parent => :main,
      :wrapper => 'Address_!!!',
      :address => 'Address1',
      :city => 'City',
      :state => 'State',
      :zip => 'Zipcode'
    }

    @elements[:business_details] ||= {
      :alternate_business_name => '.akaMark',
      :website => '.businessWebsiteUrlMark',
      :website_description => '.businessWebsiteDescriptionMark',
      :phone_type => '.businessPhoneEditor select',
      :mobile_phone => '.businessPhoneEditor .phoneNumberMark',
      :alternate_email => '.emailAddressMark'
    }

    @elements[:business_hours] ||= {
      :members => {
        :mon => 'Monday',
        :tues => 'Tuesday',
        :wed => 'Wednesday',
        :thur => 'Thursday',
        :fri => 'Friday',
        :sat => 'Saturday',
        :sun => 'Sunday'
        },
      :expand_weekdays => '/#expandWeekdaysLink',
      :start_time => '#!!!_row select',
      :end_time => '#!!!_row select.endTimeSelect',
      :is_closed => '#!!!_row .closeCheck'
    }

    @elements[:payment_methods] ||= {
      :wrapper => '#Selected!!!',
      :cash => 'PaymentOptions_12',
      :checks => 'PaymentOptions_7',
      :paypal => 'PaymentOptions_8',
      :visa => 'CreditCards_2',
      :mastercard => 'CreditCards_3',
      :amex => 'CreditCards_4',
      :discover => 'CreditCards_5',
      :diners => 'CreditCards_11'
    }

    @elements[:captcha] ||= {
      :captcha_field => '#captcha',
      :captcha_image => 'img[alt="CAPTCHA"]',
      :submit => 'input[alt="continue"]',
      :verification => ':contains("Sign Up")'
    }

    @elements[:registration] ||= {
      :email => '#RepeatEmail',
      :password => '#Password',
      :password_confirmation => '#RepeatPassword',
      :secret_question => '#SecurityQuestion',
      :secret_answer => '#SecurityAnswer',
      :terms_of_service => '#TermsOfUse',
      :submit => '#submitButton',
      :verification => ':contains("Verify Listing")'
    }

    @elements[:login] ||= {
      :email => '#Email',
      :password => '#Password',
      :submit => 'input[type=image]'
    }
    @elements
  end
end

SignUp.new("Adsolutionsyp",data,self).verify