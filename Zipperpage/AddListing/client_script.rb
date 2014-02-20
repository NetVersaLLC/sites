#Method for create listing  
def create_listing(data) 
  #Fill form on Step -I
  @browser.link(:text => "Advertise").click	
  @browser.text_field(:name,'get_company').set data[ 'business' ]
  @browser.text_field(:name,'get_first_name').set data[ 'first_name' ]
  @browser.text_field(:name,'get_last_name').set data[ 'last_name' ]
  @browser.select_list(:name => 'get_ref_country').select 'United States'
  @browser.text_field(:name => 'get_phone').set data[ 'phone' ]
  @browser.text_field(:name => 'get_address').set data[ 'address' ]
  @browser.text_field(:name => 'get_city').set data[ 'city' ]
  @browser.text_field(:name => 'get_zip').set data[ 'zip' ]
  @browser.text_field(:name => 'get_email').set data[ 'email' ]
  @browser.text_field(:name => 'get_main_category').set data[ 'category' ]
  @browser.text_field(:name => 'get_website').set data[ 'website' ]
  @browser.select_list(:name => 'get_ref_state').select data[ 'state' ]
  enter_captcha( data )
  #Check if business get listed
  @success_msg = "Thank you for submitting your company information"
  if @browser.text.include?(@success_msg)
	  puts "Business get listed successfully"
	  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Zipperpage'
  true
  end  
end
def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\zipperpage_captcha.png"
  obj = @browser.image(:src=> /image.php/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  sleep(3)
  CAPTCHA.solve image, :manual
end

def enter_captcha( data )

  capSolved = false
  count = 1
  until capSolved or count > 5 do
  captcha_code = solve_captcha.upcase
  @browser.text_field( :name, 'get_sign_crypt').set captcha_code
  @browser.button(:src => /final-design2.png/).click
  sleep(4)
  if not @browser.text.include? "Enter the Right Word on The Access Code Below"
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

@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end
# Main Script start from here
# Launch url
@url = 'http://www.zipperpages.com'
@browser.goto(@url)
#Create Listing
create_listing(data) 

