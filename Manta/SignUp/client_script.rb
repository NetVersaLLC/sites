@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}


def signup(data) 
  @browser.goto('http://www.manta.com')

  @browser.link(:id => "signup-nav-header").click 

  Watir::Wait.until{ @browser.text.include?("Join Manta")} 

  @browser.text_field(:id => "firstname").set data['first_name']
  @browser.text_field(:id => "lastname").set data['last_name']
  @browser.text_field(:id => "member-email").set data['email']
  @browser.text_field(:id => "new-password").set data['password']

  @browser.button(:id => "SUBMIT").click
  
  if @browser.text.include?("already registered") 
    puts "Already registered"
    return :already_registered
  end 

  if @browser.text.include?("Get The Most out of Manta") 
    self.save_account("Manta", {:email=>data['email'], :password => data['password'], :status => 'Account created.'})
    puts "success"
    return :success
  end 

  throw "There was an error while creating the account."
end 

signup(data)

if @chained
  self.start("Manta/CreateListing")
end
self.success

true
