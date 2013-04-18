@browser.goto('http://my.citysquares.com/search')
@browser.text_field( :name => 'b_standardname').set data['business']
@browser.text_field( :name => 'b_zip').set data['zip']
@browser.button( :id => 'edit-b-search').click
sleep(5)
businessFound = []
 if @browser.link( :text => data['business']).exists?
 em = @browser.link( :text => data['business'])
 if em.exists?
   if em.parent.parent.link( :id => 'claimButton').exists?
     businessFound = [:listed,:unclaimed]
   else
     businessFound = [:listed,:claimed]
   end
  else
     businessFound = [:unlisted]
  end
  else 
     businessFound = [:unlisted]
  end

[true, businessFound]
