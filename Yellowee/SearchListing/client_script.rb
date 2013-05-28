@browser.goto("http://www.yellowee.com/search?what=#{data[ 'businessfixed' ]}&where=#{data['city']}%2C+#{data['state']}%2C+United+States")


if @browser.text.include? "Sorry, we didn't find any results for"
  
  businessFound = [:unlisted]
  puts("Unlisted")
else
Watir::Wait.until { @browser.div( :id => 'result_1').exists? }
sleep(3)#ajax screws the wait up. This short sleep seems to fix that problem. 
if @browser.link( :title => /#{data['business']}/i).exists?
    @browser.link( :title => /#{data['business']}/i).click
    Watir::Wait.until { @browser.link( :id => 'writereview').exists? }   
    if @browser.link( :title => 'Claim Business').exists?
        businessFound = [:listed, :unclaimed]
        puts("listed, uncalimed")
    else   
        businessFound = [:listed, :claimed]
        puts("listed, claimed")
    end  
 else
    businessFound = [:unlisted]
    puts("unlisted")
 end  
  
  
end


[true, businessFound]