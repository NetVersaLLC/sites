class Runner
  attr_reader :data

  def main(data)
    @data = data
    @brow = Watir::Browser.new :firefox
    try_do :signup, 3
    wait_for_page_load
    if @brow.element(:css => '#timer-message a').exists?
       @brow.element(:css => '#timer-message a').click            
       wait_for_page_load       
    else 
      if @brow.element(:id=> 'captchaV5Answer').exists?
        try_do :enter_captcha, 3
        wait_for_page_load
      end      
      if @brow.element(:id => 'mobile').exists?
        phone_verify
        code = PhoneVerify.retrieve_code("Yahoo")
        input_verification_sms(code)
      end
    end
  ensure
    @brow.close if @brow
  end

  def input_verification_sms(code)
    wait_for_page_load
    txt_set({:id => 'verification-code'}, code.to_s)
    @brow.button(:type => 'submit').click
  end
  
  def signup
    signup_url = "https://edit.yahoo.com/registration"
    @brow.goto signup_url
    wait_for_page_load
    txt_set({:name=> 'firstname'},            @data['firstname'])
    txt_set({:name=> 'secondname'},           @data['lastname'])
    
    try_do :make_yahoo_id, 3

    txt_set({:name=> 'password'},             @data['password'])
    txt_set({:name=> 'mobileNumber'},         @data['mobile'])

    try_do :select_value, 3, {:id=> 'month'},  data['bday_month'].to_s
    try_do :select_value, 3, {:id=> 'day'},    data['bday_day'].to_s
    try_do :select_value, 3, {:id=> 'year'},   data['bday_year'].to_s
    @brow.radio(:name=> 'gender',:value =>    @data['gender']).set
    
    @brow.button(:type => 'submit').click
    Watir::Wait.while { @brow.text_field(:name=> 'firstname').exists? }
    true
  end

  def make_yahoo_id
    username= @data['username']+(rand(2**20)%941).to_s
    txt_set({:name=> 'yahooid'}, username)    
    sleep 3
    Watir::Wait.until{ @brow.p(:id => 'user-name-validation-message').text.strip == "" }
    @data['yahoo_username']= username
    true
  end

  def solve_captcha
    image = "#{ENV['USERPROFILE']}\\citation\\yahoo1_captcha.png"
    obj = @brow.img(:class, 'captchaImage' )
    puts "CAPTCHA source: #{obj.src}"
    puts "CAPTCHA width: #{obj.width}"
    obj.save image
    return CAPTCHA.solve(image, :manual)
  rescue Exception => e
      puts(e.inspect)
  end

  def enter_captcha
    captcha_code = solve_captcha 
    @brow.text_field(:id=> 'captchaV5Answer').set captcha_code
    sleep(5)
    @brow.button(:type=> 'submit').click
    sleep 15
    return (not @brow.text_field(:id=> 'captchaV5Answer').exists?)
  end

  def phone_verify
    wait_for_page_load
    txt_set({:id => 'mobile'}, @data['verification_mobile'])
    @brow.button(:type => 'submit').click
  end

  def txt_set(selector, keys)
    keys.is_a?(String) ? @brow.text_field(selector).set(keys) : 
      @brow.text_field(selector).send_keys(keys)
    true
  end

  def send_keys(selector, keys)
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
        return
      end
      puts  "retrying #{func}"
      raise "retrying #{func}"
    rescue Exception => e
      retries+=1
      retry if retries< n
      puts  "exhauseted on retries in #{func} due to \n'#{e}'"
      raise "exhauseted on retries in #{func} due to \n'#{e}'"
    end
  end
  
end

runner= Runner.new
runner.main(data)
data= runner.data
self.save_account('Yahoo',  {:email => data['yahoo_username'],:password => data['password']})
if @chained
  self.start("Yahoo/CreateListing")
end
true
