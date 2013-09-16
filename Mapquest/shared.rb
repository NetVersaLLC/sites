def sign_in( data )
	@browser.goto("https://listings.mapquest.com/apps/signin")
	@browser.text_field(:name, "username").when_present.set data['email']
	@browser.text_field(:name, "password").set data['password']
	@browser.span(:class => "btn-var-inner", :text => "Sign In").click
end