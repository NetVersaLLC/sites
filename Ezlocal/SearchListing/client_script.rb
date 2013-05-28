@browser.goto('http://ezlocal.com/')

@browser.text_field( :id => 'tQ').set data['business']
@browser.text_field( :id => 'tBy').set data['citystate']

@browser.button( :name => 'bSearch').click

sleep(5)
businessFound = []

begin 
  @browser.link( :title => data['business']).exists?
  
  begin
    @browser.link( :title => data['business']).parent.parent.parent.div(:class => 'actionbar').div( :class => 'claim' ).exists?
     businessFound = [:listed, :unclaimed]
  rescue Timeout::Error
     businessFound = [:listed, :claimed] 
  end
  
rescue Timeout::Error
  businessFound = [:unlisted]
end

#puts(businessFound)
[true, businessFound]
