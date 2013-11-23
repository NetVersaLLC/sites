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
def add_listing(data)
	@browser.text_field(:name => 'ListContact').when_present.set data[ 'full_name' ]
	@browser.text_field(:name => 'ReqEmail').when_present.set data[ 'email' ]
	@browser.text_field(:name => 'ListOrgName').set data[ 'business' ]
	@browser.text_field(:name => 'ListAddr1').set data[ 'address' ]
	@browser.text_field(:name => 'ListCity').set data[ 'city' ]
	@browser.text_field(:name => 'ListState').set data[ 'state' ]
	@browser.text_field(:name => 'ListZip').set data[ 'zip' ]
	@browser.text_field(:name => 'ListPhone').set data[ 'phone' ]
	@browser.text_field(:name => 'ListWebAddress').set data[ 'website' ]
	@browser.text_field(:name => 'ListStatement').set data[ 'business_description' ]

	#Enter Decrypted captcha string here
	enter_captcha

	@browser.link(:href => 'thankyou.php').when_present.click
        @browser.wait()
	@confirmation_msg = 'Your submission was successful and has now been sent to our review department.'
        
	if @browser.text.include?(@confirmation_msg)
		puts "Initial registration Successful"
		RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ],'model' => 'Discoverourtown'
		true
		else
		throw "Initial registration not successful"
	end
end

# Main Steps

# Launch url
url = 'http://www.discoverourtown.com/add/'
@browser.goto(url)
#Add listing
add_listing(data)
