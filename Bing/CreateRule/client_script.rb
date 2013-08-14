sign_in( data )
@browser.goto( 'mail.live.com/mail/options.aspx' )


sleep 2
Watir::Wait.until{@browser.link(:id => "iShowSkip").exists? or @browser.frame( :id, 'appFrame').exists?}
if @browser.link(:id => "iShowSkip").exists?
	@browser.link(:id => "iShowSkip").click
	sleep 2
	Watir::Wait.until(360) { @browser.text.include? "Account summary" }
	@browser.goto( 'mail.live.com/mail/options.aspx' )	

	sleep 2
	Watir::Wait.until{@browser.frame( :id, 'appFrame').exists?}	
end


@opt_frame = @browser.frame( :id, 'appFrame')
@opt_frame.link( :text, /Rules for sorting new messages/i).when_present.click
@opt_frame.button( :id, 'NewFilter').when_present.click

@opt_frame.select_list( :id, 'VerbDropDown').select "contains"
@opt_frame.text_field( :id, 'MatchString').set "@"
@opt_frame.button( :value, /Save/).click

if @chained
		self.start("Bing/CreateListing")
end

true

