
@browser = Watir::Browser.new :firefox

at_exit {
  unless @browser.nil?
    @browser.close
  end
}


def add_business(data)
  @browser.goto("http://yellowwiz.com/add_business.php")
  @browser.text_field(:name => /visitor/).when_present.set data[ 'username' ]
  @browser.text_field(:name => /visitormail/).set data[ 'email' ]
  @browser.text_field(:name => /phone/).set data[ 'phone' ]
  @browser.text_field(:name => /business/).set data[ 'business' ]
  @browser.text_field(:name => /address/).set data[ 'address' ]
  @browser.text_field(:name => /city/).set data[ 'city' ]
  @browser.text_field(:name => /state/).set data[ 'state' ]
  @browser.text_field(:name => /zip/).set data[ 'zip' ]
  @browser.text_field(:name => /keyword/).set data[ 'keywords' ]
  @browser.text_field(:name => /notes/).set data[ 'business_description' ]

  #The captacha logic.

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\yellowwiz_captcha.png" 
  obj = @browser.img( :id, 'phoca-captcha' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

def enter_captcha( data )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha
    @browser.text_field( :id, 'captcha').set captcha_code
    @browser.button(:value => 'Send').click
    sleep(4)
    if not @browser.text.include? "Image Verification is incorrect."
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
  enter_captcha(data)

  #Check for confirmation
  Watir::Wait.until { @browser.text.include? 'Listing Submission Done!' }
  @success_text ="Listing Submission Done!"
  if @browser.text.include? @success_text
    puts "Business has been claimed successful"
    #RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ], 'account[password]' => data['password'], 'model' => 'Yellowwiz'
    # There is no information to save.
    #self.save_account("yellowwiz", {:username => data[ 'username' ], :password => data[ 'password' ], :email => data[ 'email' ]})
    return true
  else
    throw "Business has not been claimed successful"
  end  
end
    
#~ #Main Steps
add_business(data)