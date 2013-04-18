@browser.goto('http://www.mycitybusiness.net/search.php')
@browser.text_field(:name => 'kword').set data['business']

@browser.text_field(:id => 'city').set data['city']

@browser.select_list( :name => 'state').select_value data[ 'state_short' ] 

@browser.link(:xpath => '//*[@id="quick_search_form"]/div/a[2]').click


sleep(3)
Watir::Wait.until { @browser.text.include? "Searching for" }


if @browser.text.include? "0 Results"
  businessFound = [:unlisted]
  
else
  
  if @browser.text.include? data['business']
  
    businessFound = [:listed, :claimed]
  else
  
    businessFound = [:unlisted]
  end  
end
[true,businessFound]