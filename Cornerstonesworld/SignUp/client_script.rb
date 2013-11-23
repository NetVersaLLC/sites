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
puts(data['category'])
@browser.goto( 'http://www.cornerstonesworld.com/index.php?page=addurl' )

@browser.text_field( :id => 'cname').set data[ 'business' ]
@browser.select_list( :id => 'cat').select data['category']	
@browser.text_field( :id => 'addrcl').set data[ 'address' ]
@browser.text_field( :id => 'citycl').set data[ 'city' ]
@browser.text_field( :id => 'zipcl').set data[ 'zip' ]
@browser.select_list( :id => 'countrycl').select data['country']
@browser.select_list( :id => 'state').when_present.select data['state']
@browser.text_field( :id => 'phonecl').set data[ 'phone' ]
@browser.text_field( :id => 'phone2cl').set data[ 'phone2' ]
@browser.text_field( :id => 'faxcl').set data[ 'fax' ]
@browser.text_field( :id => 'mphonecl').set data[ 'mobilephone' ]
@browser.text_field( :id => 'web').set data[ 'website' ]
@browser.text_field( :id => 'emailcl').set data[ 'email' ]

@browser.text_field( :id => 'namecl').set data[ 'name' ]
@browser.text_field( :id => 'snamecl').set data[ 'namelast' ]
@browser.select_list( :id => 'sexcl').select data[ 'gender' ]
@browser.text_field( :id => 'jobcl').set data[ 'jobtitle' ]
@browser.checkbox( :id => 'newsch').click

enter_captcha


self.save_account("Cornerstonesworld", {:password => data['password']})
	if @chained
		self.start("Cornerstonesworld/Verify")
	end
true


