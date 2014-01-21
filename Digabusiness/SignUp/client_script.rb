@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def solve_captcha_signup
  image = "#{ENV['USERPROFILE']}\\citation\\digabusiness_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="padding"]/form/table/tbody/tr[8]/td[2]/img' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"

  obj.save image
  CAPTCHA.solve image, :manual
end

def enter_captcha_signup( data )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha_signup 
    @browser.text_field( :id => 'CAPTCHA').set captcha_code
    @browser.button( :name => 'submit').click
    sleep(2)
    if not @browser.text.include? "Invalid code."
      capSolved = true
    end   
  count+=1
  end
  if capSolved == true
    true
  else
    self.failure("Captcha was not solved")
  end
end

def signup(data)
    @browser.goto("http://www.digabusiness.com/profile.php?mode=register&agreed=true")

    @browser.text_field(:name => 'LOGIN').when_present.set data['username']
    @browser.text_field(:name => 'NAME').set data['fname'] + " " + data['lname']
    @browser.text_field(:name => 'PASSWORD').set data['password']
    @browser.text_field(:name => 'PASSWORDC').set data['password']
    @browser.text_field(:name => 'EMAIL').set data['email']
    @browser.checkbox(:name => 'AGREE').set
rescue => e
  unless @retries == 0
    puts "Error caught in signup: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in signup could not be resolved. Error: #{e.inspect}"
  end
end

if data[ 'website' ].nil? || data['website'] == ""
  self.success("Client does not have a website")
else
  @retries = 3

  signup(data)

  enter_captcha_signup( data )

  Watir::Wait.until { @browser.text.include? "Thank you for registering. Your account has been created." } #effectively an IF
	self.save_account("Digabusiness", {:username => data['username'], :email => data['email'], :password => data['password'], :status => "Account created, creating Listing..."})
	if @chained
	  self.start("Digabusiness/AddListing")
  	end
  self.success
end
