url = data[ 'url' ]
if url.nil?
	if @chained
		self.start("Iniderpage/Verify", 1440)
	end
end
@browser.goto(url)

if @chained
  self.start("Insiderpage/HandleListing")
end

true
