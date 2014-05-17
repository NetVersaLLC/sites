eval(data['payload_framework'])
class SignUp < PayloadFramework
  def run
    browser.goto 'crunchbase.com/account/signup'
    enter :first_name
    enter :last_name
    enter :email
    enter :email_confirmation, data[:email]
    enter :password
    enter :password_confirmation, data[:password]
    check :terms_of_service
    submit
  end

  def verify
    wait_until { browser.text.include? "Your CrunchBase account has been created!" }
    click :confirm
    save :email, :password
    true
  end

  def setup_elements
    @elements[:main] = {
      :wrapper => '#user_!!!',
      :first_name => 'first_name',
      :last_name => 'last_name',
      :email => 'email',
      :email_confirmation => 'email_confirmation',
      :password => 'password',
      :password_confirmation => 'password_confirmation',
      :terms_of_service => '/#tos',
      :submit => '/#submit',
      :confirm => '.auth-component > a:nth-child(2)'
    }
  end
end

SignUp.new('Crunchbase',data,self)