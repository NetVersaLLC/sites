@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

def sign_in(data)
  @browser.link(:text => 'Log In/Join').click
  @browser.text_field(:id => 'session_email').set data['email']
  @browser.text_field(:id => 'session_password').set data['password']
  @browser.button(:value => 'Log In').click
 
  Watir::Wait.until{ @browser.div(:id => "footer-links").text =~ /Log Out/ }
end

def get_listing_url(data)
  @browser.link(:text => "Businesses" ).click
  @browser.h1(:text => "Managed Businesses").wait_until_present
  @browser.link(:text => data['business']).href
end 

@browser.goto 'https://www.getfave.com/login'
sign_in(data)
listing_url = get_listing_url(data)

if listing_url
  self.save_account("Getfave", {:listing_url => listing_url})
  self.success
else
  self.failure("listing not found.")
end


