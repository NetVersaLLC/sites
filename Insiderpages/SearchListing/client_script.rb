sign_in data

search_business data

Watir::Wait.until { @browser.text.include? 'There were 0 results' or @browser.link(:text => /#{data['business']}/).exist? }

if @browser.text.include? 'There were 0 results'
  businessFound['status'] = :unlisted
elsif @browser.link(:class => 'content search_result search_result_clickable clearfix').link(:text => /#{data['business']}/).exist?
    @browser.link(:class => 'content search_result search_result_clickable clearfix').link(:text => /#{data['business']}/).click

    if @browser.text.include? 'Claim Business'
        businessFound['status'] = :claimed
    else
        businessFound['status'] = :listed
    end
  else
  businessFound['status'] = :unlisted
end  

[true, businessFound]