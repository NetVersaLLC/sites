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

def sign_up( data )

  # assert url starts with 'https://listings.expressupdateusa.com/Account/Register'
  puts 'Signing up with email: ' + data[ 'personal_email' ]

  @browser.goto 'https://listings.expressupdateusa.com/Account/Register'

  @browser.text_field(:id => 'Email').set data['email']
  @browser.text_field(:id => 'Password').set data['password']
  @browser.text_field(:id => 'ConfirmPassword').set data['password']
  @browser.text_field(:id => 'Phone').set data['phone']
  @browser.text_field(:id => 'BusinessName').set data['business_name']
  @browser.text_field(:id => 'FirstName').set data['firstname']
  @browser.text_field(:id => 'LastName').set data['lastname']
  @browser.select_list(:id => 'State').select data['state']
  @browser.checkbox(:id => 'DoesAcceptTerms').set


enter_captcha

@browser.button(:class => 'RegisterNowButton').click

  # If no return URl then 'Thank You for Registering with Express Update. An activation email sent!'

self.save_account("Expressupdateusa", { :email => data['personal_email'], :password => data['password']})


if @chained
    self.start("Expressupdateusa/Verify")
end


true 
end


@browser.goto('https://listings.expressupdateusa.com/Account/Register')
sign_up( data )
true
