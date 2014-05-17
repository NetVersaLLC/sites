eval(data['payload_framework'])
class CreateListing < PayloadFramework
  def run
    login
    enter_business_info
    enter_hours_of_operation
    enter_payment_methods
    enter_languages
    submit
    wait_until_present :submit
    if browser.text.include? "Choose the Correct Address"
      submit
    end
    choose_category
    until browser.text.include? "Preview Your Profile"
      wait_until_present :submit
      submit
    end
    check :terms_of_service
    click :publish
  end

  def verify
    wait_until { browser.text.include? "confirm your profile!" }
    chain 'Verify'
    true
  end

  def login
    context(:login) {
      browser.goto 'https://register.kudzu.com/login.do'
      wait_until_present :username
      enter :username
      enter :password
      submit
    }
  end

  def enter_business_info
    context(:business_info) {
      wait_until_present :salutation
      select :salutation
      enter :first_name
      enter :last_name
      enter :company_name
      enter :website
      enter :address
      enter :address2
      enter :city
      select :state
      enter :zip
      enter :phone_area_code
      enter :phone_prefix
      enter :phone_suffix
      enter :phone_extension
      enter :fax_area_code
      enter :fax_prefix
      enter :fax_suffix
    }
  end

  def enter_hours_of_operation
    context(:business_hours) {
      data[:days_open].each do |day|
        select :"#{day}:start_time"
        select :"#{day}:start_merid"
        select :"#{day}:end_time"
        select :"#{day}:end_merid"
      end
      data[:days_closed].each do |day|
        check :"#{day}:closed"
      end
    }
  end

  def enter_payment_methods
    context(:payment_methods) {
      data[:payment_methods].each do |payment_method|
        check :"#{payment_method}"
      end
    }
  end

  def enter_languages
    context(:languages_spoken) {
      data[:languages_spoken].each do |language|
        check :"#{language}"
      end
    }
    enter :year_founded
  end

  def choose_category
    browser.goto 'https://register.kudzu.com/browseCategories.do?categoryGroup=0'
    click :category
    wait_until_present :submit
    submit
  end

  def setup_elements
    @elements[:main] = {
      :category => "a:contains('#{data[:category]}')",
      :terms_of_service => '[name=businessAgreement]',
      :publish => '[name=submitButton]',
      :submit => '[name=nextButton]'
    }

    @elements[:login] = {
      :wrapper => '[name=!!!]',
      :username => 'username',
      :password => 'password',
      :submit => 'login'
    }

    @elements[:business_info] = {
      :wrapper => '[name=!!!]',
      :salutation => 'prefix',
      :first_name => 'firstName',
      :last_name => 'lastName',
      :company_name => 'businessName',
      :website => 'website',
      :address => 'busAddress1',
      :address2 => 'busAddress2',
      :city => 'busCity',
      :state => 'busState',
      :zip => 'busZip1',
      :phone_area_code => 'busNPA',
      :phone_prefix => 'busNXX',
      :phone_suffix => 'busPlusFour',
      :phone_extension => 'busExtension',
      :fax_area_code => 'busFaxNPA',
      :fax_prefix => 'busFaxNXX',
      :fax_suffix => 'busFaxPlusFour',
      :submit => 'nextButton'
    }  

    @elements[:business_hours] = {
      :members => {
        :mon => 'monday',
        :tues => 'tuesday',
        :wed => 'wednesday',
        :thur => 'thursday',
        :fri => 'friday',
        :sat => 'saturday',
        :sun => 'sunday'
      },
      :wrapper => '[name=!!!]',
      :start_time => '!!!Open',
      :start_merid => '!!!OpenMeridiem',
      :end_time => '!!!Close',
      :end_merid => '!!!CloseMeridiem',
      :closed => '!!!Closed'
    }

    @elements[:payment_methods] = {
      :wrapper => '[name=paymentTypeSelectedAnswers][value=!!!]',
      :cash => '320360',
      :checks => '678',
      :visa => '675',
      :mastercard => '674',
      :amex => '673',
      :discover => '676',
      :diners => '677',
      :paypal => '325480',
    }

    @elements[:languages_spoken] = {
      :wrapper => '[name=languagesSpokenSelectedAnswers][value=!!!]',
      :english => '700',
      :french => '718',
      :korean => '729',
      :spanish => '701',
      :other_language => '320362',
      :year_founded => '/[name=yearEstablished]'
    }
  end
end

CreateListing.new('Kudzu',data,self).verify