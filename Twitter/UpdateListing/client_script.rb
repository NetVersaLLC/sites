# Developer's Notes
# Let's Update!

# Browser Code
@browser = Watir::Browser.new :firefox
at_exit do
    unless @browser.nil?
        @browser.close
    end
end

# Methods
def signin(data)
  retries ||= 3
  @browser.goto("https://twitter.com/login")
  @browser.element(:css, 'form.clearfix:nth-child(2) > fieldset:nth-child(1) > div:nth-child(2) > input:nth-child(1)').send_keys data['username']
  @browser.element(:css, 'form.clearfix:nth-child(2) > fieldset:nth-child(1) > div:nth-child(3) > input:nth-child(1)').send_keys data['password']
  @browser.element(:css, 'form.clearfix:nth-child(2) > div:nth-child(3) > button:nth-child(4)').click
  if not @browser.button(:id, 'global-new-tweet-button').present?
    raise "Login failed"
  end
rescue => e
  retry unless (retries -= 1).zero?
  self.failure(e)
else
  puts "Logged in"
end

def update_profile(data)
  retries ||= 3
  # TODO - Image Upload
  @browser.goto("https://twitter.com/settings/profile")
  @browser.text_field(:id, 'user_name').set data['name']
  @browser.text_field(:id, 'user_location').set data['state']
  unless data['website'].nil?
    if not data['website'].include? 'http://'
      data['website'] = 'http://' + data['website']
    end
    @browser.text_field(:id, 'user_url').set data['website']
  end
  if data['bio'].length > 160
    data['bio'] = data['bio'].split(".")[0] + '. ' + data['bio'].split(".")[1] + '.'
    if data['bio'].length > 160
      @browser.text_field(:id, 'user_description').set data['bio'].split(".")[0] + '.'
    else
      @browser.text_field(:id, 'user_description').set data['bio']
    end
  else
    @browser.text_field(:id, 'user_description').set data['bio']
  end
  @browser.button(:id, 'settings_save').click
  Watir::Wait.until { @browser.text.include? "Thanks, your settings have been saved." }
rescue => e
  retry unless (retries -= 1).zero?
  self.failure(e)
else
  puts "Account updated"
  self.success
end

# Controller
signin(data)
update_profile(data)
