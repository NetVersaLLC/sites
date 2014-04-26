eval(data['payload_framework'])
class SignUp < PayloadFramework
  def run
    browser.goto 'reviews.bizzspot.com/sign-up'
    browser.goto browser.frame.when_present.src
    wait_until_present :first_name
    browser.execute_script 'jQuery("html").css("overflow","visible");'
    enter :first_name
    enter :last_name
    enter :phone_area_code
    enter :phone_prefix
    enter :phone_suffix
    enter :email
    enter :company_name
    enter :address
    enter :address2
    enter :city
    select :state
    enter :category
    enter :zip
    enter :business_phone_area_code 
    enter :business_phone_prefix 
    enter :business_phone_suffix
    enter :fax_area_code
    enter :fax_prefix
    enter :fax_suffix
    enter :business_email
    enter :website
    check :terms_of_service
    submit
  end

  def verify
    wait_until { browser.url.split('/').last == 'thanks.php' }
    save :email, :password
    true
  end

  def setup_elements
    @elements[:main] = {
      :wrapper => '#Field!!!',
      :first_name => '15',
      :last_name => '16',
      :phone_area_code => '6',
      :phone_prefix => '6-1',
      :phone_suffix => '6-2',
      :email => '143',
      :company_name => '20',
      :address => '33',
      :address2 => '34',
      :city => '35',
      :state => '38',
      :category => '31',
      :zip => '39',
      :business_phone_area_code => '27',
      :business_phone_prefix => '27-1',
      :business_phone_suffix => '27-2',
      :fax_area_code => '29',
      :fax_prefix => '29-1',
      :fax_suffix => '29-2',
      :business_email => '28',
      :website => '145',
      :terms_of_service => '42',
      :submit => '/#saveForm'
    }
  end
end

SignUp.new('Bizzspot',data,self).verify