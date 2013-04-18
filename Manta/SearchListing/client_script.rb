@browser.goto('http://www.manta.com/')

@browser.text_field( :name => 'search').set data[ 'query' ]
sleep(2)
@browser.button( :class => 'button').click
sleep(4)

begin 
  @browser.image( :id => 'skip').exists?
  @browser.image( :id => 'skip').click
rescue Timeout::Error

end


sleep(5)

businessFound = []
if @browser.text.include? "We couldn't find any companies that matched your selections"
    businessFound = [:unlisted]
else
    begin
      @browser.link( :text => data['business']).exists?
      @browser.link( :text => /#{data['business']}/).click
        begin 
            @browser.div( :class => 'aside own_this_business').exists?
            businessFound = [:listed, :unclaimed]
        rescue Timeout::Error
            businessFound = [:listed, :claimed]
        end
    rescue Timeout::Error
    
    end
     
end

return true, businessFound