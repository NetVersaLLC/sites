url = sign_in(data)
@browser.goto(url+ "directory/category/arts-entertainment#modal_dialog:ugc_listing_modal_dialog")

@browser.text_field(:name => 'listing[name]').set data['business']
@browser.text_field(:name => 'listing[phone]').set data['phone']

@browser.label(:text => data['category1']).click
sleep 2
@browser.label(:text => data['category2']).click

@browser.text_field(:name => 'keywordz').set data['address']
sleep(5)
@browser.link(:text => /Select/, :index => 0).click

sleep(5)
puts("submitting")
@browser.button(:xpath => '//*[@id="listing_submit"]').click

sleep(10)# another spot where waits just don't seem to work. 
#I think it might have something to do with the dozens of javascript errors on the site.
if not @browser.text.include? "To receive a free listing you need to be located within the boundaries of this Patch"

true

else
	throw("You are not within the bounds of this Patch")
end




