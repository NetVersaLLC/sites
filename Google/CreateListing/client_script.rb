# Upload photo on google profile
def photo_upload_pop(photo)
	require 'rautomation'
	photo_upload_pop = RAutomation::Window.new :title => /File Upload/
	photo_upload_pop.text_field(:class => "Edit").set(photo)
	photo_upload_pop.button(:value => "&Open").click
end

def create_business( data )

	puts 'Business is not found - Creating business listing'
	
	@browser.goto "https://plus.google.com/pages/create"
	@browser.div(:class => "W0 pBa").click
	@browser.div(:class => "W0 pBa").click if @browser.div(:class => "W0 pBa").exist?
	@browser.div(:class => /AX kFa a-yb Vn a-f-e a-u-q-b/).when_present.click
	@browser.div(:text => "#{data['country']}").click
	@browser.text_field(:class, 'RBa Vn xBa c-cc LB-G ia-G-ia').set data['phone']
	@browser.div(:class => "a-f-e c-b c-b-M LC").click
	
	while not @browser.div(:class, "zX").exists? # No matches located
		sleep(3)
		puts 'Waiting on "No matches located" to appear.'
	end

	# Basic Information
	@browser.div(:class => "rta Si").click
	@browser.text_field(:xpath, "//input[contains(@label, 'Enter your business name')]").set data['business']
	@browser.text_field(:xpath, "//input[contains(@label, 'Enter your full business address')]").set data['address']
	@browser.text_field(:class=>'c-cc g9jP6 M3LyOb').set data['category']
	#~ @browser.text_field(:xpath, "//input[contains(@label, 'Address')]").send_keys :tab
	@browser.button(:name, 'ok').click
	@browser.text_field(:name => 'PlusPageName').when_present.set data['business']
	@browser.text_field(:name => 'Website').set data['website']
	@browser.div(:class => 'goog-inline-block goog-flat-menu-button-dropdown').click
	#~ @browser.div(:text, "#{data['business_category']}").click
	@browser.div(:text => 'Any Google+ user').click
	@browser.checkbox(:name => 'TermsOfService').set
	@browser.button(:value => 'Continue').click
        
	if not data[ 'image' ] == nil
  	  # Upload photo
	  @browser.div(:text => 'Add your logo').when_present.click
	
	  if @browser.wait_until { @browser.span(:text, 'Select profile photo').exist? }
		@browser.div(:id => /select-files-button/).div(:index, 0).when_present.click
		@browser.div(:id => /select-files-button/).div(:index, 1).click if @browser.div(:id => /select-files-button/).div(:index, 1).exist?
		photo = data[ 'image' ]
		photo_upload_pop(photo)
		Watir::Wait.until { @browser.div(:text, 'To crop this image, drag the region below and then click "Set as profile photo"').exist? }
		Watir::Wait.until { @browser.div(:text, 'Add Caption').exist? }
		@browser.div(:text => 'Set as profile photo', :index => 1).when_present.click
	  end
	
	  @browser.wait_until { @browser.div(:text => 'Set as profile photo', :index => 1).visible? != true }
	end

	@browser.div(:text => 'Finish', :index => 1).click
	@browser.wait

	# Confirmation
	
	if @browser.div(:class => 'inproduct-guide-modal').exist?
		@browser.link(:text => 'x').when_present.click
	end
	
	# Update profile
	@browser.div(:text => 'Edit profile').click
	@browser.div(:text => 'About').click
	@browser.span(:class => 'nzBhDb').click
	@browser.wait_until {@browser.frame(:class, /editable/).exist?}
	@browser.frame(:class, /editable/).send_keys data['business_introduction']
	@browser.div(:text => 'Save').when_present.click
	@browser.div(:text => 'Done editing').when_present.click
	
	if @browser.div(:class , 'we lc l-eh').text.include?(data['business'])
		puts "Business successfully Registered"
		verify_business()
	else
		throw "Business successfully not Registered"
	end
end

def verify_business()
	if @browser.div(:class => 'a-f-e c-b c-b-M BNa').exist?
		puts "Sending request for verification"
		@browser.div(:class => 'a-f-e c-b c-b-M BNa').when_present.click
		@browser.wait()
		@browser.checkbox(:id, 'gwt-uid-50').when_present.set #terms
		@browser.link(:text, 'Request postcard').click
	end
end

login( data )
search_for_business( data )
create_business( data )
