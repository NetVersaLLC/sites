@browser.goto("http://www.expressbusinessdirectory.com/businesses/#{data['businessfixed']}/")
if @browser.text.include? "Sorry, no search results found."
  businessFound = [:unlisted]
else
 if @browser.link( :text => /#{data['business']}/).exists?
    @browser.link( :text => /#{data['business']}/).click
    Watir::Wait.until { @browser.div(:class => 'blueText').exists? }
    if @browser.link( :id => 'ctl00_ContentPlaceHolder1_hypClaimBusiness').exists?
      businessFound = [:listed, :unclaimed]
    else
      businessFound = [:listed, :claimed]    
    end  
 else
    businessFound = [:unlisted]
 end        
end


[true, businessFound]