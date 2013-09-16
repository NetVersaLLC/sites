# Global Retry Count, affects all rescue
@retries = 5

# Methods

def add_login_details( data )
	@browser.goto("http://byzlyst.com/wp-login.php?action=register")
	@browser.text_field(:id, "user_login").when_present.set data['username']
	@browser.text_field(:id, "user_email").set data['email']
	@browser.text_field(:id, "password").set data['password']
	@browser.text_field(:id, "rpassword").set data['password']
rescue => e
  unless @retries == 0
    puts "Error caught while adding login details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while adding login details could not be resolved. Error: #{e.inspect}"
  end
end

def add_account_details( data )
	@browser.text_field(:id, "first_name").set data['fname']
	@browser.text_field(:id, "last_name").set data['lname']
	@browser.button(:id, "submit").click
	@browser.img(:src, /account.png/).wait_until_present
rescue => e
  unless @retries == 0
    puts "Error caught while adding account details: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while adding account details could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
add_login_details( data ) # Goes to site, generates username & password
add_account_details( data ) # Fills out first & last name, submits, waits to confirm success

if @chained
	self.start("Byzlyst/AddListing")
end

true