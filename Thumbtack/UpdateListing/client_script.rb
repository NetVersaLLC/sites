sign_in(data)
@browser.goto("http://www.thumbtack.com/profile/dashboard")

@browser.link(:text => 'Edit profile').click

# Updating title and business name.
@browser.text_field(:name => 'sav_business_name').when_present.set data ['business']
@browser.text_field(:name => 'sav_title').set data ['title']
@browser.textarea(:name => 'sav_description').set data ['description']
@browser.link(:text => 'Save changes').click
sleep 2
Watir::Wait.until { @browser.span(:xpath => "//div[@class='button-holder small clear-block']//span").exist? }

# Updating location.
@browser.link(:xpath => "//div[@id='address-module']//a[text()='Edit']").click
@browser.select_list(:id => "usa_users_addr_id").select "Enter new address below"
@browser.text_field(:id => "usa_address1").set data['address']
@browser.text_field(:id => "usa_address2").set data['address2']
@browser.text_field(:id => "usa_zip_code_id").set data['zip']
@browser.span(:xpath => "//div[@id='address-module']//span").click
sleep 2
Watir::Wait.until { @browser.link(:xpath => "//div[@id='address-module']//a[text()='Edit']").exist? }

# Updating phone number.
@browser.link(:xpath => "//div[@id='phone-module']//a[text()='Edit']").click
@browser.select_list(:id => "phn_phone_number_id").select "Enter new phone number below"
@browser.text_field(:name => "phn_phone_number").set data['phone']
@browser.span(:xpath => "//div[@id='phone-module']//span").click
sleep 2
Watir::Wait.until { @browser.link(:xpath => "//div[@id='phone-module']//a[text()='Edit']").exist? }

# Updating website URL.
@browser.link(:xpath => "//div[@id='website-module']//a[text()='Edit']").click
@browser.text_field(:name => "web_website").set data['website']
@browser.span(:xpath => "//div[@id='website-module']//span").click
sleep 2
Watir::Wait.until { @browser.link(:xpath => "//div[@id='website-module']//a[text()='Edit']").exist? }

# Updating logo
unless self.logo.nil? 
  data['logo'] = self.logo
else
  data['logo'] = self.images.first unless self.images.nil?
end

unless data['logo'].nil?
  @browser.link(:text => 'Manage pictures').click

  if @browser.link(:text => 'Delete picture').exist?
    @browser.link(:text => 'Delete picture').click
    Watir::Wait.until { @browser.text.include? "Learn more about images on Thumbtack." }
  end

  @browser.link(:text => 'Try the alternate picture uploader.').click

  @browser.file_field(:name => 'Filedata').set data['logo']
  @browser.span(:xpath => "//span[@class='upload-when-html']/a/span").click
  sleep 2
  Watir::Wait.until { @browser.link(:text => 'Use as profile picture').exist? }
  @browser.link(:text => 'Use as profile picture').click
  Watir::Wait.until { !@browser.link(:text => 'Use as profile picture').exist? }
end

true