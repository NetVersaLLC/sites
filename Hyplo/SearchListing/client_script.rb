@browser.goto('http://www.hyplo.com')

@browser.text_field( :id => 'search_term').set data['business']
@browser.text_field( :id => 'search_location').set data['zip']

@browser.button( :text => 'Search').click
sleep(5)

Watir::Wait.until { @browser.text.include? "Hyperlocal sites for" }

if @browser.div(:class => 'span12 foundsite').exists?
    if @browser.link( :text => /#{data['business']}/).exists?
        businessFound = [:listed,:claimed]
    else
         businessFound = [:unlisted]
    end
else
  businessFound = [:unlisted]
end
 
 
[true, businessFound]