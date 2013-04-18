@browser.goto('http://www.supermedia.com/spportal/quickbpflow.do')

@browser.text_field( :name => 'phone').set data['phone']
@browser.link( :id => 'getstarted-search-btn').click

@browser.link( :text => 'select', :index => 0 ).when_present.click
@browser.link( :text => 'next', :index => 0 ).when_present.click

if @browser.text.include? "Our records indicate this business listing has already been claimed"
  businessFound = [:listed, :claimed]
  

elsif @browser.text_field( :id => 'busname').value != ""
  businessFound = [:listed, :unclaimed]
  
else
  businessFound = [:unlisted]

end

return true, businessFound