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

def enter_captcha b
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

@browser.goto( 'http://www.askyp.com/contact.php' )
@browser.text_field( :name, 'FirstName').set data[ 'firstname' ]
@browser.text_field( :name, 'LastName').set data[ 'lastname' ]
@browser.text_field( :name, 'Uemail').set data[ 'email' ]
@browser.text_field( :name, 'Phone').set data[ 'phone' ]
@browser.select_list( :name, 'AUD').select data[ 'add' ]
@browser.text_field( :name, 'URL').set data[ 'website' ]
@browser.text_field( :name, 'Message').set data[ 'message' ]

enter_captcha( data )

true
