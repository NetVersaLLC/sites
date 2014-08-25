class Runner
  attr_reader :data

  def main(data)
    @data = data
    @browser = Watir::Browser.new :firefox
    try_do :sign_up, 3
    enter_captcha
  ensure
    @browser.close if @browser
  end

  def set_text(selector, keys)
    @browser.text_field(selector).clear
    keys.each_char{ |char| 
      @browser.text_field(selector).send_keys(char)
    }
  rescue
    @browser.text_field(selector).set(keys)
  end

  def wait_for_page_load
    Watir::Wait.until{ @browser.execute_script("return document.readyState == 'complete';") }
  end

  def try_do func, n, *args
    retries = 0
    begin
      if result = self.send(func, *args)
        return
      end
      puts  "retrying #{func}"
      raise "retrying #{func}"
    rescue Exception => e
      retries += 1
      retry if retries < n
      msg = "exhausted on retries in #{func} due to \n'#{e}' at #{@brow ? @brow.url : 'nowhere!' }"
      puts  msg
      raise msg
    end
  end

  def solve_captcha
    image = "#{ENV['USERPROFILE']}\\citation\\allthelocal_captcha.png"
    @browser.img(:id, "phoca-captcha").save image
    sleep(3)
    CAPTCHA.solve image, :manual
  end

  def enter_captcha
    capSolved = false
    count = 1
    until capSolved or count > 5 do
      captcha_code = solve_captcha  
      @browser.text_field(:id, 'captcha').when_present.set captcha_code.upcase
      @browser.button(:value => 'Send').when_present.click  
      wait_for_page_load
      sleep(4)
      if @browser.text.include? "Thank You"
        capSolved = true
      end
      count+=1
    end
    if capSolved == true
      true
    else
      throw("Captcha was not solved")
    end
  end

  def sign_up
    @browser.goto "http://allthelocal.com/add_business.php"
    set_text({:name => "visitor"},     @data['contact_name'])
    set_text({:name => "visitormail"}, @data['email'])
    set_text({:name => "phone"},       @data['local_phone'])
    set_text({:name => "business"},    @data['business_name'])
    set_text({:name => "address"},     @data['address'])
    set_text({:name => "city"},        @data['city'])
    set_text({:name => "state"},       @data['state'])
    set_text({:name => "zip"},         @data['zip'])
    set_text({:name => "keyword"},     @data['keywords'])
    set_text({:name => "url"},         @data['company_website'])
    set_text({:name => "notes"},       @data['business_description'])
  end

end

@heap = JSON.parse( data['heap'] ) 
if @heap.length == 0 
  @heap = JSON.parse( "{\"signed_up\": true, \"listing_created\": false, \"account_verified\": true, \"listing_updated\": false}" )
  self.save_account("Allthelocal", {"heap" => @heap.to_json})
end

if data['email'].to_s.empty? || data['password'].to_s.empty? 
  runner = Runner.new
  runner.main(data)
  data = runner.data
  self.save_account("Allthelocal", { :status => "Listing created." } )
end

@heap['listing_created'] = true 
self.save_account("Allthelocal", {"heap" => @heap.to_json})
true
