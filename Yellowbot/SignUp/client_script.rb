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

@browser.goto( "https://www.yellowbot.com/signin/register" )

  @browser.text_field( :id => 'reg_email' ).set data[ 'email' ]
  @browser.text_field( :id => 'reg_email_again' ).set data[ 'email' ]

  @browser.text_field( :id => 'reg_name' ).set data[ 'username' ]
  @browser.text_field( :id => 'reg_password' ).set data[ 'password' ]
  @browser.text_field( :id => 'reg_password2' ).set data[ 'password' ]
  
  @browser.checkbox( :name => 'tos' ).set
  @browser.checkbox( :name => 'opt_in' ).clear

	enter_captcha
  
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'YellowBot'
  
  if @chained
	  self.start("Yellowbot/Verify")
	end
  
  
  true