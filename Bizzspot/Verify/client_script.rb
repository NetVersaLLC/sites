@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

url = data[ 'link' ]
@browser.goto(url)

@browser.text_field(:id => /customer_password/).set data[ 'pass' ]
@browser.text_field(:id => /customer_password_confirmation/).set data[ 'pass' ]
@browser.button(:name => /commit/).click
if Watir::Wait::until { @browser.text.include? 'Password successfully updated' }
	puts('Profile confirmed!')
	true
end