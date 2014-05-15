@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}
def sign_in( data )
	@browser.goto( 'https://www.thumbtack.com/login' )
	@browser.text_field( :id => 'login_email').set data['email']
	@browser.text_field( :id => 'login_password').set data['password']
	# sleep 50
	@browser.button( :class => 'submit-bttn').click
end

sign_in(data)
@browser.goto("http://www.thumbtack.com/welcome?continue=true")

@browser.select_list(:xpath ,'/html/body/div[2]/div/form/fieldset/div/select').when_present.select 'Home Improvement'
# puts "abcd34"
@browser.button( :class => 'bttn').click
@browser.checkbox(:label=>'Interior Design').set
# puts "2345"
@browser.button(:xpath => '/html/body/div[2]/div[2]/div/form/div[3]/button').click
# puts "234567"
sleep 20
@browser.text_field(:name => 'street').when_present.set data['address']
@browser.text_field(:name => 'city').set data['city']
@browser.text_field(:name => 'state').set data['state']
@browser.text_field(:name => 'zip').set data['zip']
# @browser.text_field(:name => 'website').set data['website']
@browser.button( :xpath => '/html/body/div[2]/div[2]/div[2]/form/div[3]/button').click
@browser.checkbox(:label=>'I travel to my customers').set
@browser.checkbox(:label=>'My customers travel to me').set
@browser.checkbox(:label=>'Neither (phone or Internet only)').set

@browser.button(:xpath=>'/html/body/div[2]/div[2]/div[3]/form/div[3]/button').click

sleep 2
 
@browser.text_field(:name => 'name').set data['business']
@browser.text_field(:name => 'website').set data['website']
@browser.textarea(:name => 'description').set data['description']

@browser.button(:xpath=>'/html/body/div[2]/div[2]/div[4]/form/div[3]/button').click

@browser.text_field(:name => 'firstName').when_present.set data['address']
@browser.text_field(:name => 'lastName').set data['city']
@browser.text_field(:name => 'email').set data['email']
@browser.text_field(:name => 'phone').set data['phone']

@browser.button(:xpath=>'/html/body/div[2]/div[2]/div[5]/form/div[3]/div/button').click
sleep 30
puts "Yor are successfully listed."
true

# @browser.text_field(:name => 'sav_business_name').when_present.set data['business']
# @browser.text_field(:name => 'phone_number').set data['phone']
# # @browser.text_field(:name => 'website').set data['website']

# data['descriptionfixed'] = data['description']
# data['descriptionfixed'] = "#{data['descriptionfixed']}\n#{data['description']}" while data['descriptionfixed'].length < 200

# @browser.textarea(:name => 'sav_description').set data['descriptionfixed']
# @browser.text_field(:name => 'sav_title').set data['title']

# @browser.select_list(:name => 'address_id').select "Enter New Address Below"
# @browser.text_field(:name => 'usa_address1').set data['address']

# @browser.text_field(:name => 'usa_zip_code_id').set data['zip']
# @browser.checkbox(:value => 'toprovider').set

# @browser.link(:text => /List my services/).click

# # Check for Error
# 30.times { break if @browser.status == "Done"; sleep 1 }
# if @browser.div(:class,'form-error').visible?
#   throw "Validation Fails : #{@browser.div(:class,'form-error').text}"
# end
# if @browser.div(:class => 'status status-error').visible?
#   throw "Validation Fails : #{ @browser.div(:class => 'status status-error').text }"
# end
# sleep 2
# Watir::Wait.until { @browser.text.include? "Connect Your Facebook Account" }
# @browser.link(:text => /Skip this step/).click

# # Uploading logo.
# unless self.logo.nil? 
#   data['logo'] = self.logo
# else
#   data['logo'] = self.images.first unless self.images.nil?
# end

# unless data['logo'].nil?
#   @browser.link(:text => 'Use an alternate picture uploader.').click

#   @browser.file_field(:name => 'Filedata').set data['logo']
#   @browser.span(:xpath => "//span[@class='upload-when-html']/a/span").click
#   sleep 2
#   Watir::Wait.until { @browser.link(:text => 'Use as profile picture').exist? }
#   @browser.link(:text => 'Use as profile picture').click
#   Watir::Wait.until { !@browser.link(:text => 'Use as profile picture').exist? }
#   @browser.span(:text => /Continue »/).click
# else
#   @browser.link(:text => /Skip this step/).click
# end

# @browser.goto("http://www.thumbtack.com/profile/dashboard")
# sleep 2
# Watir::Wait.until { @browser.text.include? data['title'] } 
# true
