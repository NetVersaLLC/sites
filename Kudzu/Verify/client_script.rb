url = data[ 'link' ]
@browser.goto(url)

if @browser.text.include? 'Your profile will be published within 48 hours.'
	puts('Profile confirmed!')
	true
end

