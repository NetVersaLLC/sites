@browser.goto('http://www.shopbrazos.com/')

@browser.text_field( :id => 'project').set data['business']
@browser.text_field( :id => 'searchCity').set data['business']
@browser.button( :name => 'frmSubmit').click

sleep(3)
Watir::Wait.until { @browser.h2(:text => 'SEARCH RESULTS') }

if @browser.text.include? "There are no listings located for"
  businessFound = [:unlisted]
else
  if @browser.link(:text => /#{data['business']}/).exists?
    @browser.link(:text => /#{data['business']}/).click
    Watir::Wait.until { @browser.div( :class => 'ListingsPageBusinessBlock').exists? }
    if @browser.link(:title => 'Claim  | Shop Brazos').exists?
      businessFound = [:listed, :unclaimed]
    else
      businessFound = [:listed, :claimed]
    end
    
  else
    businessFound = [:unlisted]
  end
  
end

[true,businessFound]