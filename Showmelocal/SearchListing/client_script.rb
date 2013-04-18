@browser.goto("http://www.showmelocal.com/local_search.aspx?q=#{data['businessfixed']}&s=#{data['state_short']}&c=#{data['city']}")


if @browser.div(:class => 'serachresult').div(:class => 'h').link( :text => /#{data['business']}/i).exists?
    @browser.div(:class => 'serachresult').div(:class => 'h').link( :text => /#{data['business']}/i).click
        Watir::Wait.until { @browser.link(:id => '_ctl5_hlBusinessName').exists? }
      if @browser.link( :id => '_ctl5_hlAreYourTheOwner').exists?          
          businessFound = [:listed,:unclaimed]
      else
          businessFound = [:listed,:claimed]
      end
 else
    businessFound = [:unlisted]
 end  
 
 
[true, businessFound]