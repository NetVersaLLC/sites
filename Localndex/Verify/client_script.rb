@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

url = data[ 'link' ]
if url.nil?
	self.start("Localndex/Verify", 1440)
else
	@browser.goto(url)
	30.times{ break if @browser.status == "Done"; sleep 1}
	if @browser.text.include? 'Account activated'
		puts('Profile confirmed!')
	end
end

true