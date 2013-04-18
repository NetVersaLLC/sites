sign_in(data)

sleep 2

@browser.link(:xpath => '//*[@id="content"]/form/div[1]/div/table/tbody/tr/td[1]/table/tbody/tr[2]/td[1]/a').click

@browser.link(:xpath => '//*[@id="reviewForm"]/table/tbody/tr[1]/td[1]/div/h4/span[2]/a').click

Watir::Wait.until {@browser.text_field(:name => 'listing.businessName').set data['business']}

@browser.text_field(:name => 'listing.contact').set data['phone']
@browser.text_field(:name => 'listing.secondaryContact').set data['tollfree']
@browser.text_field(:name => 'listing.emailaddress').set data['email']
@browser.text_field(:name => 'listing.faxNumber').set data['fax']
@browser.text_field(:name => 'listing.tollfreeNumber').set data['tollfree']
@browser.text_field(:name => 'bpinfo.displayUrl').set data['url']
@browser.text_field(:name => 'bpinfo.websiteUrl').set data['url']
@browser.text_field(:name => 'listing.address.address1').set data['addressComb']
@browser.text_field(:name => 'listing.address.city').set data['city']
@browser.select_list(:name => 'listing.address.state').select data['state']
@browser.text_field(:name => 'listing.address.zip').set data['zip']

@browser.text_field(:name => 'bpinfo.businessDescription').set data['desc']
@browser.text_field(:name => 'bpinfo.businessSince').set data['founded']

@browser.button(:name => '_eventId_submit').click

Watir::Wait.until { @browser.text.include? "select categories that get your business noticed" }

thecount = @browser.links(:text => 'remove').size

(1..thecount).each do |i|
	@browser.link(:text => 'remove').click
end

cats = data['categories']
cats.each do |cat|
	@browser.text_field(:name => 'searchtext').set cat
	@browser.button(:value => 'search').click

	sleep (1) while @browser.image(:id => 'load-icon').visible?

	next if @browser.text.include? "Sorry, we didn't find any category results."

	@browser.divs(:class => "draggable-list-item ui-draggable").each do |thecats|
		puts(thecats.class_name)
		next if thecats.class_name == "draggable-list-item ui-draggable ui-draggable-disabled ui-state-disabled"
			thecats.span(:class => 'addlink').click
		break
	end



end

@browser.button(:src => 'https://www.supermedia.com/img/img-spportal/buttons/continue.gif').click

Watir::Wait.until { @browser.text.include? "Your changes have been saved" }

true



