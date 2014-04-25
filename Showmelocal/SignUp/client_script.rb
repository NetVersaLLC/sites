eval(data['payload_framework'])
class SignUp < PayloadFramework
  def run
    url = 'http://www.showmelocal.com/register.aspx?ReturnURL=/business-registration.aspx'
    browser.goto url
    enter :first_name
    enter :last_name
    enter :email
    enter :password
    solve { submit; browser.text.include? "you logged in as" }
    wait_until_present :company_name
    enter :company_name
    enter :category
    enter :phone
    enter :address
    enter :zip
    solve { submit; browser.text.include? "Your account requires activation" }
  end

  def verify
    save :email, :password
    chain 'Verify'
  end

  def setup_elements
    @elements = {}
    @elements[:main] = {
      :wrapper => '#_ctl0_txt!!!',
      :first_name => 'FirstName',
      :last_name => 'LastName',
      :email => 'Email',
      :password => 'Password',
      :company_name => 'BusinessName',
      :category => 'BusinessType',
      :phone => 'Phone',
      :address => 'Address',
      :zip => 'Zip',
      :captcha_image => '/#imgWVI',
      :captcha_field => '/#txtWordVeritication',
      :submit => '/#cmdSave'
    }
  end
end

SignUp.new('Showmelocal',data,self).verify