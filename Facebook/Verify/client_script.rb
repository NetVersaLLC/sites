@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

def solve_verify_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\facebook_captcha.png"
  if @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/).exists?
    obj = @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/)
  elsif @browser.image(:src, /recaptcha\/api\/image/).exists?
    obj = @browser.image(:src, /recaptcha\/api\/image/)
  else
    throw "A wild new captcha appears!"
  end
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def retry_verify_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_verify_captcha
    @browser.text_field(:name=> 'captcha_response').when_present.set captcha_text
    @browser.button(:name =>'submit[Submit]').click

     sleep(5)
    if not @browser.text.include? "The text you entered didn't match the security check. Please try again."
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

begin
  link = data['link']
  if link.nil? then
    if @chained
      self.start("Facebook/Verify", 1440)
    end
  else
    @browser.goto(link)
    if @browser.text.include? "You must log in to continue."
      @browser.text_field(:id, 'pass').set data['password']
      @browser.button(:name, 'login').click
    end
    if @browser.text.include? "Enter"
      retry_verify_captcha(data)
      sleep(3)
    elsif @browser.text.include? "Please Verify Your Identity"
      if @browser.button(:value, 'Continue').exists?
        @browser.button(:value, 'Continue').click
        retry_verify_captcha(data)
        if @browser.text.include? "Please Complete a Security Check"
          puts "Phone Verification Required"
          if @chained
            self.start("Facebook/Notify")
          end
        else
          puts "Verification success"
          if @chained
            self.start("Facebook/CreateListing")
          end
        end
      end
    elsif @browser.button(:value =>'Find Friends').exist?
      puts "Verification success"
      if @chained
        self.start("Facebook/CreateListing")
      end
    else
      puts "Verification failure"
    end
  end
rescue => e
  raise e.inspect
end
true