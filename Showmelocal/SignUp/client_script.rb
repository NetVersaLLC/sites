@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

#BEGIN CAPTCHA
def solve_captcha( obj )
  image = ["#{ENV['USERPROFILE']}",'\citation\site_captcha.png'].join
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha( button, field, image, successTrigger, failureTrigger=nil )
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha(image)
    field.set captcha_code
    button.click

    30.times{ break if @browser.status == "Done"; sleep 1}
    
    unless failureTrigger.nil? or @browser.text.include? failureTrigger
      capSolved = true
    end
    
  count+=1  
  end
  if capSolved == true
    Watir::Wait.until { @browser.text.include? successTrigger }
    true
  else
    throw("Captcha was not solved")
  end
end
#END CAPTCHA

def try_captcha(successTrigger)
  5.times do |n|
    begin
      button = @browser.button(:id=>"cmdSave")
      field = @browser.text_field(:id=>"txtWordVerification")
      image = @browser.image(:id=>"imgWVI")
      enter_captcha(button,field,image,successTrigger)
    rescue
      if n<4
        puts "Captcha failed. Retrying #{4-n} more times."
      else
        puts "Captcha failed. Out of retries."
      end
    end
    break
  end
end

@browser.goto 'http://www.showmelocal.com/register.aspx?ReturnURL=/business-registration.aspx'

@browser.text_field(:id => '_ctl0_txtFirstName').set data['contact_first_name']
@browser.text_field(:id => '_ctl0_txtLastName').set data['contact_last_name']
@browser.text_field(:id => '_ctl0_txtEmail').set data['email']
@browser.text_field(:id => '_ctl0_txtPassword').set data['password']
try_captcha("you logged in as")

@browser.text_field(:id => '_ctl0_txtBusinessName').when_present.set data['business_name']
@browser.text_field(:id => '_ctl0_txtBusinessType').set data['category2']
@browser.text_field(:id => '_ctl0_txtPhone').set data['alternate_phone']
@browser.text_field(:id => '_ctl0_txtAddress').set data['address']
try_captcha("Your account requires activation")

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Showmelocal'
	if @chained
		self.start("Showmelocal/Verify")
	end
true
