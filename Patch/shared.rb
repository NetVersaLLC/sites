def find_site(data)
	@browser.goto("http://www.patch.com/")
	@browser.text_field(:id => 'zip').set data['zip']
	@browser.button(:value => 'FIND MY PATCH').click
	sleep 2
	Watir::Wait.until { @browser.div(:class => /zip_search_message/).exists? }
	if @browser.div(:class => /errors/).exists?
		throw("Patch.com does not support your city")
	end

	return @browser.div(:class => "nearby_patches").links.first.attribute_value('href')
end