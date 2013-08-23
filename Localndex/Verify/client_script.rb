url = data[ 'link' ]
@browser.goto(url)
30.times{ break if @browser.status == "Done"; sleep 1}
if @browser.text.include? 'Account activated'
	puts('Profile confirmed!')
	true
end

