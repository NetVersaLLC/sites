@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end
def sign_in(data)
  @browser.goto("http://www.magicyellow.com/login.cfm")
  @browser.text_field(:id => 'login').set data['email']
  @browser.text_field(:name => 'password').set data['password']
  @browser.button(:value => 'Submit').click
end

def remove_images 
  delete = @browser.link(:text => "Delete")
  if delete.exist?
    delete.click
    remove_images
  end 
end 

def update_listing(data)
  @browser.link(:href => /bizcentereditprofile/).click

  @browser.text_field(:name => 'ServicesExtra').set data[ 'additional_services' ]
  @browser.text_field(:name => 'ProductsExtra').set data[ 'additional_products' ]
  @browser.text_field(:name => 'BrandsExtra').set data[ 'additional_brands' ]

  @browser.checkboxes(:name => 'biz_payment_option_type').each{|cb| cb.clear}
  data['payment_option'].each do |p|
    @browser.checkbox(:name => 'biz_payment_option_type', :value => p).set
  end 
  @browser.button(:value => 'Save').click

  @browser.link(:href => /bizcenterphotos/).click
  bizid = @browser.url.match(/bizid=(\d+)\z/)[1]
  remove_images

  @browser.goto "http://www.magicyellow.com/bizcenterphotos_manual.cfm?bizid=#{bizid}"
  self.images.each do |p|
    f = File.join("#{ENV['USERPROFILE']}\\citation\\#{@bid}\\images", p)
    puts "sending image #{f}"
    @browser.file_field(:name => 'img1').set f 
    @browser.button(:value => "Upload selected files!").click
  end 
  @browser.goto "http://www.magicyellow.com/bizcenter.cfm"

  "http://www.magicyellow.com" + @browser.link(:href => /\/profile/).href
end 

sign_in(data)
listing_url = update_listing(data)

self.save_account("Magicyellow", {:listing_url => listing_url, :status => "Listing updated."})
self.success

