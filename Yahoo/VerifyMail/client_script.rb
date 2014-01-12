class Runner
  attr_reader :data

  def main(data)
    @data= data
    @brow = Watir::Browser.new :firefox
    binding.pry
    try_do :login, 3
    try_do :go_to_verify, 3
    try_do :enter_verification_code, 3
  ensure
    @brow.close if @brow
  end

  def login
    signin_url=    'https://login.yahoo.com/config/login_verify2?.done=http%3A//smallbusiness.yahoo.com/dashboard/mybusinesses%3Fbrand%3Dysb&.src=msdash'
    @brow.goto signin_url
    ########################
    txt_set({:id=> 'username'}, @data['username'])
    txt_set({:id=> 'passwd'  }, @data['password'])
    @brow.button(:id=> '.save').click
    Watir::Wait.while{ @brow.text_field(:id => 'username').exists? }
    true
  end
  
  def go_to_verify
    wait_for_page_load
    @brow.goto 'http://smallbusiness.yahoo.com/dashboard/mybusinesses?brand=ysb' 
    verify_anchor= verify_anchor= @brow.a(:class=> "verify first")
    verify_anchor.click
    Watir::Wait.while{ verify_anchor.exists? }
    true
  end
  
  def enter_verification_code
    wait_for_page_load
    code = PhoneVerify.retrieve_code("Yahoo")
    txt_set({:id=> 'txtCaptcha'}, code)
    result= @brow.execute_script("return verifyChannel('inline');")
    # <div id="verif-msg-done"><p id="">The verification code you submitted was incorrect. Please enter the new verification code.</p></div>
    # Thank you for verifying your business.
    Watir::Wait.until{ @brow.p(:id=> 'verif-form-alerts-child').exists? }
    result= @brow.div(:class=> 'captcha-pass').exists?
    if result 
      puts "verification was succesfull"
      return true
    else
      puts "verification failed"
      return false
    end
  end

  def txt_set(selector, keys)
    keys.is_a?(String) ? @brow.text_field(selector).set(keys) : 
      @brow.text_field(selector).send_keys(keys)
    true
  end

  def send_keys(selector, keys)
    sleep 1
    if keys.is_a? String
      @brow.text_field(selector).clear
      keys.each_char{ |char| @brow.text_field(selector).send_keys(char) }
    else
      @brow.text_field(selector).send_keys(keys)
    end
  end

  def select_value selector, val
    option= @brow.select(selector).option(:value=> val)
    @brow.execute_script("return arguments[0].selected= 'selected'", option)
    Watir::Wait.until{ 
      @brow.select(selector).value == val 
    } 
    true
  end

  def wait_for_page_load
    Watir::Wait.until{ @brow.execute_script("return document.readyState == 'complete';")}
  end

  def try_do func, n, *args
    retries= 0
    begin
      if result= self.send(func, *args)
        return result
      end
      puts  "retrying #{func}"
      raise "retrying #{func}"
    rescue Exception => e
      retries+=1
      retry if retries< n
      msg= "exhauseted on retries in #{func} due to \n'#{e}'"
      puts msg 
      raise msg
    end
  end

end

runner= Runner.new
runner.main(data)
data= runner.data
true
