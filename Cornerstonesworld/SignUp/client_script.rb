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

    sleep 10

    if not @browser.text.include? "SECURITY AUTHENTICATION"
      capSolved = true
    else
      capSolved = false
    end
    
  count+=1  
  end
  if capSolved == true
    true
  else
    throw("Captcha was not solved")
  end
end
#END CAPTCHA
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
@browser.text_field( :id => 'web').set data[ 'website' ]
@browser.text_field( :id => 'emailcl').set data[ 'email' ]
@browser.execute_script("document.getElementById('cat').value = '#{data[ 'category' ]}';")
#@browser.select_list( :id => 'cat').select data[ 'category' ]

button = @browser.button(:name=>'register')
field = @browser.text_field(:id => 'capchacl1')
image = @browser.image(:id=>'cap')
enter_captcha(button,field,image,"Account manager's details")

#@browser.link(:class => 'linkclose', :index => 2).when_present.click
@browser.element(:xpath => '//*[@id="hspop"]/div[1]/a').click
@browser.text_field( :id => 'namecl').set data[ 'name' ]
@browser.text_field( :id => 'snamecl').set data[ 'namelast' ]
@browser.select_list( :id => 'sexcl').select data[ 'gender' ]
@browser.text_field( :id => 'jobcl').set data[ 'jobtitle' ]
@browser.text_field(:id=>'pwdcl').set data['password']
@browser.text_field(:id=>'pwdccl').set data['password']
unless @browser.checkbox( :id => 'subch').disabled?
  @browser.checkbox( :id => 'subch').clear
end
@browser.checkbox( :id => 'newsch').clear
@browser.checkbox( :id => 'agreecl').click

@browser.button( :value => 'Finish').click

Watir::Wait.until  {@browser.text.include?"Thank you for registering." }

self.save_account("Cornerstonesworld", {:password => data['password']})
	if @chained
		self.start("Cornerstonesworld/Verify")
	end
true


