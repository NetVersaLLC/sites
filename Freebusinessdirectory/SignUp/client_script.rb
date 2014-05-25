@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def solve_captcha
  img = @browser.image(:id => 'validn_img')
  image = ["#{ENV['USERPROFILE']}",'\citation\fbd_captcha.png'].join
  puts "CAPTCHA source: #{img.src}"
  puts "CAPTCHA width: #{img.width}"
  img.save(image)
  sleep 1
  CAPTCHA.solve image, :manual
end

@browser.goto( 'http://freebusinessdirectory.com/signup.php' )

@browser.text_field(:id => 'company_name').set data['business_name']
@browser.text_field(:id => 'firstname').set data['contact_first_name']
@browser.text_field(:id => 'lastname').set data['contact_last_name']
@browser.text_field(:id => 'email').set data['email']
@browser.text_field(:id => 'user_id').set data['userid']

5.times do
  @browser.text_field(:id => 'pass1').set data['password']
  @browser.text_field(:id => 'pass2').set data['password']
  @browser.text_field(:id => 'validn_code').set( solve_captcha )

  @browser.button(:id => 'newcompany').click

  Watir::Wait.until do 
    @browser.td(:text => /Incorrect validation code/).exist? || 
      @browser.text.include?("SMTP")
  end 
  break if @browser.text.include?("SMTP")
end

if @browser.text.include?("SMTP")
  self.save_account("Freebusinessdirectory", { :username => data['userid'], 
    :email => data['email'], :password => data['password']})
    
  if @chained
    self.start("Freebusinessdirectory/Verify")
  end
  true
else 
  self.failure("captcha failed")
end 


