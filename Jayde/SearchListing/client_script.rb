@browser.goto 'http://www.jayde.com/'

@browser.text_field(:name => 'q').set data['business']
@browser.button(:name => 'search').click

Watir::Wait.until { @browser.text.include? "Sorry, no match found" or @browser.link( :class => 'biz_title').exists? }

businessFound = {}

if @browser.text.include? "Sorry, no match found"
  businessFound['status'] = :unlisted
elsif @browser.link(:text => /#{data['business']}/).exists?
    businessFound['status'] = :listed
  else
    businessFound['status'] = :unlisted
end  

[true, businessFound]