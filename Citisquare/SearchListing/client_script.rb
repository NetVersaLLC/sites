@browser = Watir::Browser.new
@browser.goto('http://my.citysquares.com/search')
@browser.text_field(:name => 'b_standardname').set data['business']
@browser.text_field(:name => 'b_zip').set data['zip']
@browser.button(:id => 'edit-b-search').click
sleep(5)
businessFound = {}
if @browser.link(:text => data['business']).exists?
  em = @browser.link(:text => data['business'])
  if em.exists?
    businessFound['listed_url']     = em.attribute_value("href")
    businessFound['listed_address'] = em.parent.text
    if em.parent.parent.link(:id => 'claimButton').exists?
      businessFound['status'] = :listed
    else
      businessFound['status'] = :claimed
    end
    else
      businessFound['status'] = :unlisted
  end
  else 
    businessFound['status'] = :unlisted
end

[true, businessFound]
