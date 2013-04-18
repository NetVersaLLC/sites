@browser.goto("http://www.yellowbot.com/")
@browser.text_field( :id => 'search-field' ).set data[ 'phone' ]
@browser.button( :value => 'Find my business' ).click #, :type => 'submit'

sleep(2)
Watir::Wait.until { @browser.ul(:class => 'locations-list').exists? or @browser.link(:href => "http://www.yellowbot.com/submit/newbusiness").exists? }
businessFound = []
found = false

if @browser.link( :text => 'submit a new business').exists?
  businessFound = [:unlisted]
else
businessFound = true
end
if businessFound == true

@browser.link( :text => '(view listing)').click

  if @browser.link( :class => 'claim-business').exists?
    businessFound = [:listed, :unclaimed]
  else
  businessFound = [:listed, :claimed]  
  end
end

[true, businessFound]