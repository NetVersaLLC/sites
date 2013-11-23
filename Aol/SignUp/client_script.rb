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

@browser.goto 'http://www.aol.com/'

@browser.link(:name => 'om_signup').click
@browser.execute_script("$('*').attr('visibility', 'visible');")
@browser.text_field(:id => 'firstName').set data['contact_first_name']
@browser.text_field(:id => 'lastName').set data['contact_last_name']
@browser.text_field(:id => 'desiredSN').set data['username']
@browser.text_field(:id => 'password').set data['password']
@browser.text_field(:id => 'verifyPassword').set data['password']
@browser.span(:id => 'dobMonthSelectBoxItArrowContainer').click
@browser.link(:class => 'selectboxit-option-anchor', :index => data['month'] - 1).click
@browser.text_field(:id => 'dobDay').set data['day']
@browser.text_field(:id => 'dobYear').set data['year']
@browser.select_list(:id => 'gender').select data['contact_gender']
@browser.text_field(:id => 'zipCode').set data['zip']
@browser.select_list(:id => 'acctSecurityQuestion').select 'What was the name of your first pet?'
@browser.text_field(:id => 'acctSecurityAnswer').set data['secret']
@browser.text_field(:id => 'mobileNum').set data['alternate_phone']
@browser.text_field(:id => 'altEMail').set data['email']
@browser.button(:id => 'signup-btn').click
@browser.h2(:class => 'sect-headline').click
@browser.body().RightClick()
@browser.button(:class => 'button signin-btn').click