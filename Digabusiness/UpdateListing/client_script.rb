sign_in(data)

@browser.link(:text => 'My Links').click

Watir::Wait.until { @browser.h3(:class => 'title', :text => 'Links').exists? } 

if @browser.text.include? "You currently have no links."
	puts("No links approved yet.")
	true
else


	
end
