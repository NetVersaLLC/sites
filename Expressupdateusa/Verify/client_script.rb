url = data[ 'url' ]
puts("the URL: ")
puts(url)
@browser.goto(url)

if @browser.text.include? 'Your account has been activated please sign in.'
	puts( 'Account verified' )
	true
end
