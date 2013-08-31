url=data['link']
@browser.goto(url)
sleep 2
Watir::Wait::until{@browser.text.include? "Account Activation"}
@browser.text_field(:name => 'txtPassword').set data['password']
@browser.button(:text => "Activate").click
30.times{ break if @browser.status == "Done"; sleep 1}
	if @chained
		self.start("Showmelocal/AddListing")
	end
true