@browser.goto('http://tupalo.com/en/discovery')

@browser.text_field( :name => 'q').set data['business']
@browser.text_field( :name => 'city_select').set data['citystate'] + ", United States"
@browser.button( :value => 'Search').click
sleep(10)

if @browser.text.include? "No spots found!"

businessFound = [:unlisted]

else
  
  
    if @browser.span( :title => /#{data['business']}/).exists?
       @browser.span( :title => /#{data['business']}/).click
        sleep(10)
       
      
          if @browser.span( :text => 'Is this your business?').exists?
             businessFound = [:listed, :unclaimed]
          else
             businessFound = [:listed, :claimed]
          end

        
    else
        businessFound = [:unlisted]
    end



end

[true, businessFound]