class Runner
  attr_reader :data

  def main(data)
    @data = data
    @brow = Watir::Browser.new :firefox
    #try_do :signup, 3
    sign_up
    if @brow.element(:css => '#timer-message a').exists?
       @brow.element(:css => '#timer-message a').click            
       wait_for_page_load       
    else 
      if @brow.element(:id=> 'captchaV5Answer').exists?
        enter_captcha
      end      
      if @brow.element(:id => 'mobile').exists?
        phone_verify
        code = PhoneVerify.retrieve_code("Yahoo")
        input_verification_sms(code)
        Watir::Wait.until{ @brow.text.include? "Your account has been successfully created!" }
      end
    end
  ensure
    @brow.close if @brow
  end

  def input_verification_sms(code)
    wait_for_page_load
    txt_set({:id => 'verification-code'}, code.to_s)
    @brow.element(:css => '.button').click
  end
  
  def sign_up
    signup_url = "https://edit.yahoo.com/registration"
    @brow.goto signup_url
    wait_for_page_load
    txt_set({:name=> 'firstname'},            @data['firstname'])
    txt_set({:name=> 'secondname'},           @data['lastname'])
    
    make_yahoo_id

    txt_set({:name=> 'password'},             @data['new_password'])
    txt_set({:name=> 'mobileNumber'},         @data['mobile'])

    @brow.select(:id => 'month').select data['bday_month'].to_s
    sleep(1)
    @brow.select(:id => 'day').select data['bday_day'].to_s
    sleep(1)
    @brow.select(:id => 'year').select data['bday_year'].to_s
    sleep(1)

    @brow.radio(:name=> 'gender',:value =>    @data['gender']).set
    
    @brow.button(:type => 'submit').click
    #Watir::Wait.while { @brow.text_field(:name=> 'firstname').exists? }
    sleep(30)
    true
  end

  def make_yahoo_id
    @brow.text_field(:name => 'yahooid').send_keys @data['firstname'] 
    sleep(5)
    @brow.ul(:id => "suggestions").lis.first.click 
    sleep(1)
    @data['yahoo_username']= @brow.text_field(:name => "yahooid").value
    true
  end

  def solve_captcha
    image = "#{ENV['USERPROFILE']}\\citation\\yahoo1_captcha.png"
    obj = @brow.img(:class, 'captchaImage' )
    puts "CAPTCHA source: #{obj.src}"
    puts "CAPTCHA width: #{obj.width}"
    obj.save image
    sleep(5)
    return CAPTCHA.solve(image, :manual)
  rescue Exception => e
      puts(e.inspect)
  end

  def enter_captcha
    3.times do 
      image = "#{ENV['USERPROFILE']}\\citation\\yahoo1_captcha.png"
      obj = @brow.img(:class, 'captchaImage' )
      puts "CAPTCHA source: #{obj.src}"
      puts "CAPTCHA width: #{obj.width}"
      obj.save image
      sleep(5)
      code = CAPTCHA.solve(image, :manual)

      @brow.text_field(:id=> 'captchaV5Answer').set code
      sleep(5)
      @brow.button(:type=> 'submit').click
      sleep 30
      return true unless @brow.text_field(:id=> 'captchaV5Answer').exists?
    end 
    raise "Could not sove captcha"
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


  def wait_for_page_load
    #sleep(30)
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
      msg= "exhausted on retries in #{func} due to \n'#{e}' at #{@brow ? @brow.url : 'nowhere!' }"
      puts  msg
      raise msg
    end
  end
  
end

@heap = JSON.parse( data['heap'] ) 
if @heap.length == 0 
  @heap = JSON.parse( "{\"signed_up\": false, \"listing_created\": false, \"account_verified\":false, \"listing_updated\":false}" )
  self.save_account("Yahoo", {"heap" => @heap.to_json})
end 

if data['email'].to_s.empty? || data['password'].to_s.empty? 
  runner= Runner.new
  runner.main(data)
  data= runner.data
  self.save_account('Yahoo',  {:email => data['yahoo_username'],:password => data['new_password'], :status => "Account created, creating listing..."})
end 

@heap['signed_up'] = true 
self.save_account("Yahoo", {"heap" => @heap.to_json})

if @chained
  self.start("Yahoo/CreateListing")
end
true
