url = data[ 'link' ]
@browser.text_field(:id => /customer_password/).set data[ 'pass' ]
@browser.text_field(:id => /customer_password_confirmation/).set data[ 'pass' ]
@browser.button(:name => /commit/).click
if Watir::Wait::until { @browser.text.include? 'Password successfully updated' }
	puts('Profile confirmed!')
	return true
end