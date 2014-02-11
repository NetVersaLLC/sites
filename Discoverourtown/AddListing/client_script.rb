# Developer's Notes
# nil

# Browser Code
@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

# Methods
def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\discoverourtown_captcha.png"
  obj = @browser.image( :src, /recaptcha/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

def enter_captcha
  capRetries ||= 3
  @browser.text_field(:name, 'recaptcha_response_field').set solve_captcha
  @browser.button(:value, 'Submit').click
  if @browser.url.include? 'failed=true'
    raise "Captcha failed"
  end
rescue => e
    retry unless (capRetries -= 1).zero?
    self.failure(e)
end

def post_listing(data)
  retries ||= 3
  @browser.goto('http://www.discoverourtown.com/add/')
  # Fillout form
  @browser.text_field(:name, 'ListContact' ).set     data['name']
  @browser.text_field(:name, 'ReqEmail' ).set        data['email']
  @browser.text_field(:name, 'ListOrgName' ).set     data['business']
  @browser.text_field(:name, 'ListAddr1' ).set       data['address']
  @browser.text_field(:name, 'ListCity' ).set        data['city']
  @browser.text_field(:name, 'ListState' ).set       data['state']
  @browser.text_field(:name, 'ListZip' ).set         data['zip']
  @browser.text_field(:name, 'ListPhone' ).set       data['phone']
  @browser.text_field(:name, 'ListTollFree' ).set    data['tollfree']
  @browser.text_field(:name, 'ListWebAddress' ).set  data['website']
  @browser.textarea(:name, 'ListStatement' ).set     data['description']
  # Captcha
  enter_captcha()
  @browser.link(:href => 'thankyou.php').when_present.click
  Watir::Wait.until { @browser.text.include? 'Thank you for Your Submission' }
rescue => e
  puts e
  retry unless (retries -= 1).zero?
  self.failure(e)
else
  self.save_account("Discoverourtown", {:status => "Listing posted!" })
  self.success
end
# Controller
post_listing(data)
