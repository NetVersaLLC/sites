urlParam = data['url'].split("=")
urlParam[1] = urlParam[1].gsub("/", "%2")

url = urlParam[0] +"="+ urlParam[1]
puts(url)

@browser.goto(url)

if @browser.text.include? "To activate registration please enter your password."
	@browser.text_field( :id => 'txtPassword').set data['password']
	@browser.button( :id => 'cmdActivate').click

true
end
