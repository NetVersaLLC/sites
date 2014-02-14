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

  3.times do 
    @browser.text_field( :id => 'CAPTCHA').set solve_captcha
    @browser.button( :name => 'submit').click

    if @browser.span(:text => /URL could not be validated/).exist? || @browser.span(:text => /Invalid URL/).exist?
      raise("Website provided is invalid.")
    end
    break if @browser.span(:text => /Domain already exists/) 
    break unless @browser.span(:text => /Invalid code/).exist?
  end

end

def solve_captcha	
  image = "#{ENV['USERPROFILE']}\\citation\\digabusiness_captcha.png"
  obj = @browser.img( :title, 'Visual Confirmation Security Code' )
  puts("image saved.")
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
	puts("About to solve the code")
  CAPTCHA.solve image, :manual
end

sign_in(data)
add_listing(data)

self.save_account("Digabusiness", {:status => "Listing created successfully!"})
true

