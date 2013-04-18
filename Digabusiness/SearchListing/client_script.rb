@browser.goto( "http://www.digabusiness.com/index.php?search=#{data['businessfixed']}" )

Watir::Wait.until { @browser.text.include? "Sorry, no records found that match your keyword" or @browser.h2(:class => 'title').exists? }

if @browser.link( :title => /#{data['business']}/i).exists?
     businessFound = [:listed, :unclaimed]
else
     businessFound = [:unlisted]
end  
  

[true, businessFound]


