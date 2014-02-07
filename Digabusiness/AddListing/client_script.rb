@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def sign_in(data)
	@browser.goto("http://www.digabusiness.com/login.php")
	@browser.text_field(:name => 'user').set data['username']
	@browser.text_field(:name => 'pass').set data['password']
	@browser.button(:name => 'submit').click
end

def add_listing( data ) 
  @browser.goto "http://www.digabusiness.com/submit.php"

  @browser.radio(:id => "LINK_TYPE_NORMAL").set
  @browser.text_field(:name => "TITLE").set data['business']
  @browser.text_field(:name => "URL").set   data['website']
  @browser.text_field( :name => 'DESCRIPTION').set data['description']
  @browser.text_field( :name => 'OWNER_NAME').set data['fullname']
  @browser.text_field( :name => 'OWNER_EMAIL').set data['email']
  @browser.text_field( :name => 'ADDRESS').set data['addressComb']
  @browser.text_field( :name => 'CITY').set data['city']
  @browser.text_field( :name => 'STATE').set data['state_name']
  @browser.text_field( :name => 'ZIP').set data['zip']
  @browser.text_field( :name => 'PHONE_NUMBER').set data['phone']
  @browser.text_field( :name => 'OFFER').set data['services']

  category_id = data['category_id']
  @browser.execute_script( "document.getElementsByName('CATEGORY_ID')[0].value='#{category_id}';") 

  data['payments'].each do |pay|
    @browser.checkbox( :id => /#{pay}/i).click
  end 

  enter_captcha( data )
end 

def solve_captcha	
  image = "#{ENV['USERPROFILE']}\\citation\\digabusiness_captcha.png"
  puts("image saved?")
  obj = @browser.img( :title, 'Visual Confirmation Security Code' )
  puts("image saved.")
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
	puts("About to solve the code")
  CAPTCHA.solve image, :manual
end

def enter_captcha( data )
	capSolved = false
	count = 1
	until capSolved or count > 5 do

		captcha_code = solve_captcha

		puts(captcha_code)
		@browser.text_field( :id => 'CAPTCHA').set captcha_code
		@browser.button( :name => 'submit').click
		sleep(2)
		if not @browser.text.include? "Invalid code."
			capSolved = true
		elsif @browser.text.include? "The URL could not be validated. Either the page does not exist or the server could not be contacted."
			raise "Website provided is invalid."
		end		  
	count+=1
	end
	if capSolved == true
		true
	else
		throw("Captcha was not solved")
	end
end

sign_in(data)
add_listing(data)

Watir::Wait.until { @browser.text.include? "We got your submission!"}
self.save_account("Digabusiness", {:status => "Listing created successfully!"})
true
