sign_in( data )
@browser.goto( 'mail.live.com/mail/options.aspx' )
@opt_frame = @browser.frame( :id, 'appFrame')
@opt_frame.link( :text, /Rules for sorting new messages/i).when_present.click
@opt_frame.button( :id, 'NewFilter').when_present.click

@opt_frame.select_list( :id, 'VerbDropDown').select "contains"
@opt_frame.text_field( :id, 'MatchString').set "@"
@opt_frame.button( :value, /Save/).click

if @chained
		self.start("Bing/CheckListing")
end

true

