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


def sign_in(data)
	url = find_site(data)
	@browser.goto(url + "signin")
	@browser.text_field(:id => 'user_email').set data['email']
	@browser.text_field(:id => 'user_password').set data['password']
	@browser.button(:id => 'user_submit').click
	Watir::Wait.until { @browser.link(:href => /users/i).exists? }
	return url
end