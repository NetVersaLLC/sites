sign_in(data)
sleep 3  #wait for login to process
@browser.goto("http://mojopages.com/business/")
sleep 2 
Watir::Wait.until {@browser.div(:id => 'freeAdvertisingPopup-modal-panel').exists? or @browser.div(:id => 'dashboard_business_info').exists?}

if @browser.checkbox(:name => 'dontShowAgain').exists?
	@browser.checkbox(:name => 'dontShowAgain').click
end

@browser.link(:text => 'Edit Business Profile').click

sleep 1
Watir::Wait.until {@browser.h3(:id => 'biz_details_title').exists? }

@browser.link(:text => 'Edit').click

sleep 1
Watir::Wait.until {@browser.text_field(:name => 'name').exists? }

@browser.text_field(:name => 'name').set data['name']
@browser.text_field(:name => 'description').set data['keywords']
@browser.text_field(:name => 'fullPhone').set data['phone']
@browser.text_field(:name => 'address.streetName').set data['address']
@browser.text_field(:name => 'address.city').set data['citystate']
@browser.text_field(:name => 'address.postalCode').set data['zip']
@browser.text_field(:name => 'url').set data['url']
@browser.text_field(:name => 'businessMetaDescription').set data['description']
@browser.button(:text => 'Submit').click

true