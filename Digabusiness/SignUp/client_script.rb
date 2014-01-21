@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

# Temporary methods from Shared.rb 
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
    throw("Captcha was not solved")
  end
end
# End Temporary Methods from Shared.rb

if data[ 'website' ].nil? || data['website'] == ""
  self.success("Client does not have a website")
else

  @browser.goto("http://www.digabusiness.com/profile.php?mode=register&agreed=true")

  @browser.text_field(:name => 'LOGIN').set data['username']
  @browser.text_field(:name => 'NAME').set data['fname'] + " " + data['lname']
  @browser.text_field(:name => 'PASSWORD').set data['password']
  @browser.text_field(:name => 'PASSWORDC').set data['password']
  @browser.text_field(:name => 'EMAIL').set data['email']
  @browser.checkbox(:name => 'AGREE').set

  enter_captcha_signup( data )


  Watir::Wait.until { @browser.text.include? "Thank you for registering. Your account has been created." } #effectively an IF
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['username'], 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Digabusiness'
	if @chained
		self.start("Digabusiness/AddListing")
  end
  self.save_account("Digabusiness", {:status => "Account created, creating listing..."})
  true
end
