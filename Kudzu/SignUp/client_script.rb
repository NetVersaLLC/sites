eval(data['payload_framework'])
class SignUp < PayloadFramework
  def run
    browser.goto 'https://register.kudzu.com/packageSelect.do'
    wait_until_present :start_button
    click :start_button
    enter :username
    enter :email
    enter :password
    enter :password_confirmation, data[:password]
    select :secret_question
    enter :secret_answer
    submit
  end
  
  def verify
    wait_until { browser.text.include? "Add Your Contact Name" }
    save :username, :email, :password, :secret_answer
    chain 'CreateListing'
    true
  end

  def setup_elements
    @elements[:main] = {
      :start_button => '[name=basicButton]',
      :username => '#userName',
      :email => '#email',
      :password => '#pass1',
      :password_confirmation => '#pass2',
      :secret_question => '#securityQuestion',
      :secret_answer => '#answer',
      :submit => '[name=nextButton]'
    }
  end
end

SignUp.new('Kudzu',data,self).verify