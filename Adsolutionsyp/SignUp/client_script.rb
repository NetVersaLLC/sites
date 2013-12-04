@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

# Temporary methods from Shared.rb

def solve_captcha2
  begin
  image = "#{ENV['USERPROFILE']}\citation\bing1_captcha.png"
  obj = @browser.img( :xpath, '//div/table/tbody/tr/td/img[1]' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

    return CAPTCHA.solve image, :manual
  rescue Exception => e
    puts(e.inspect)
  end
end

def enter_captcha
  captcharetries = 5
  capSolved = false
 until capSolved == true
	  captcha_code = solve_captcha2	
    @browser.execute_script("
      function getRealId(partialid){
        var re= new RegExp(partialid,'g')
        var el = document.getElementsByTagName('*');
        for(var i=0;i<el.length;i++){
          if(el[i].id.match(re)){
            return el[i].id;
            break;
          }
        }
      }
      
      _d.getElementById(getRealId('wlspispSolutionElement')).value = '#{captcha_code}';

      ")
      sleep(5)

      @browser.execute_script('
        jQuery("#SignUpForm").submit()
      ')

      sleep 15

    if @browser.url =~ /https:\/\/account.live.com\/summarypage.aspx/i
      capSolved = true
    else
      captcharetries -= 1
    end
    if capSolved == true
      break
    end

  end

  if capSolved == true
    return true
  else
    throw "Captcha could not be solved"
  end
end

# End Temporary Methods from Shared.rb

@browser.goto("https://adsolutions.yp.com/listings/basic")

puts(data['password'])

@browser.text_field(:id => 'BusinessPhoneNumber').set data['phone']
@browser.text_field(:id => 'BusinessName').set data['business']
@browser.text_field(:id => 'BusinessOwnerFirstName').set data['fname']
@browser.text_field(:id => 'BusinessOwnerLastName').set data['lname']
@browser.text_field(:id => 'Email').set data['email']

@browser.text_field(:id => 'txtCategories').set data['category']
sleep 1
@browser.link(:xpath => "/html/body/ul/li[1]/a").when_present.click
@browser.text_field(:id => 'BusinessAddress_Address1').set data['address']
@browser.text_field(:id => 'BusinessAddress_City').set data['city']
@browser.select_list(:id => 'BusinessAddress_State').select data['state']
@browser.text_field(:id => 'BusinessAddress_Zipcode').set data['zip']
@browser.text_field(:id => 'BusinessYear').set data['founded']



@browser.image(:alt => 'continue').click

begin
	sleep 2
	Watir::Wait.until(15) { @browser.text_field(:id => /BusinessWebsites/i).exists? }
rescue Watir::Wait::TimeoutError	
	if @browser.link(:id => 'selectLink').exists?
		@browser.link(:id => 'selectLink').click
		retry
	else
		throw "Payload failed. Never found @browser.text_field(:id => /BusinessWebsites/i) or @browser.link(:id => 'selectLink')."
	end
rescue Exception => e
	puts(e.inspect)
end

sleep 3
@browser.text_field(:id => /BusinessWebsites/i).when_present.set data['website']
data['payments'].each do |pay|
	@browser.checkbox(:id => pay).clear
	@browser.checkbox(:id => pay).click
end
enter_captcha
sleep 2

#Click continue button
@browser.div(:class=>'buttonContainer30').button.click

#Step 3
@browser.text_field(:id => 'RepeatEmail').when_present.set data['email']
@browser.text_field(:id => 'Password').set data['password']
@browser.text_field(:id => 'RepeatPassword').set data['password']
@browser.select_list(:id => 'SecurityQuestion').select "What is your mother's maiden name?"
@browser.text_field(:id => 'SecurityAnswer').set data['secret_answer']

@browser.checkbox(:id => 'TermsOfUse').click

@browser.button(:id => 'submitButton').click

sleep(5) #adding sleeps as it timesout after 30 seconds more often than usual. Just giving it some buffer time
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'account[secret_answer]' => data['secret_answer'], 'model' => 'Adsolutionsyp'
Watir::Wait.until {@browser.text.include? "Your listing will not be displayed on YP.com until you have completed verification."}

=begin
@browser.link(:id => 'verifyLaterPhoneLink').click

sleep(5)
Watir::Wait.until {@browser.text.include? "Your Free Listing Details"}
=end

if @chained
	self.start("Adsolutionsyp/Notify")
end

true
