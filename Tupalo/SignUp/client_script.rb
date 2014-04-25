eval(data['payload_framework'])
class Signup < PayloadFramework
  def run
    browser.goto 'tupalo.com/en/accounts/sign_up'
    enter :email
    submit
    solve {
      if browser.text.include? "already been taken"
        raise "ERROR: This account has already been registered!"
      end
      enter :email
      submit
      wait_until {
        browser.text.include? "My Favorites"
      } and true rescue false
    }
    save :email, {:username => data[:email] }
    chain 'Verify'
  end

  def setup_elements
    @elements = {}
    @elements[:main] = {
      :email => '#account_email',
      :submit => '#signin input[type=submit]',
      :captcha_image => '#recaptcha_challenge_image',
      :captcha_field => '#recaptcha_response_field'
    }
  end
end

Signup.new("Tupalo",data,self)