url = data[ 'link' ]
@browser.goto(url)
30.times{ break if @browser.status == "Done"; sleep 1}
if @browser.text.include? 'Your profile will be published within 48 hours.'
	puts('Profile confirmed!')
	true
end

