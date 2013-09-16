# Enable/Disable skipping on failure
@skip = false

# Global Retry Count
@retries = 5

# Methods
def sign_in( data )
	@browser.goto("http://www.brownbook.net/user/login/")
	@browser.text_field(:id, "email").when_present.set data['email']
	@browser.text_field(:id, "password").set data['password']
	@browser.button(:id, "submits").click
	@browser.link(:title, "Complete your profile").when_present.click
rescue => e
  unless @retries == 0
    puts "Error caught while signing in: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught while signing in could not be resolved. Error: #{e.inspect}"
  end
end

def add_description( data )
	@browser.link(:title, "Add 1 block of text").when_present.click
	@browser.first.checkbox(:id, /show_title_/).when_present.set
	@browser.first.text_field(:id, /title_/).set "Description"
	@browser.first.textarea(:id, /fck_/).set data['description']
	@browser.img(:title, "Submit changes").click
rescue => e
  unless @retries == 0
    puts "Error caught while adding business description: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
  	unless @skip == true
    	raise "Error while adding business description could not be resolved. Error: #{e.inspect}"
    else
    	puts "Skipping business description because of error: #{e.inspect}"
    end
  end
end

def add_logo( data )
	@browser.link(:title, "Add 1 logo").when_present.click
	@browser.file_field(:id, /form_file_/).when_present.set self.logo
	@browser.button(:id => "submits2", :value => "Upload").click
	sleep 2
	while @browser.img(:src, /loading.gif/).exists?
		sleep 1
	end
	@browser.img(:src, /btn_save_changes.gif/).click
rescue => e
  unless @retries == 0
    puts "Error caught while adding business logo: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
  	unless @skip == true
    	raise "Error while adding business logo could not be resolved. Error: #{e.inspect}"
    else
    	puts "Skipping business logo because of error: #{e.inspect}"
    end
  end
end

# Main Controller
sign_in( data )
add_description( data )
if self.logo != nil
	add_logo( data )
else
	puts "No Logo Found"
end
true