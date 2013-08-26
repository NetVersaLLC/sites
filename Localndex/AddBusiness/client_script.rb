def add_business(data)
@browser.goto( 'http://www.localndex.com/claim/addnew.aspx' )
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusName').set data['business']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusAddress').set data['address']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusCity').set data['city']
@browser.select_list( :id => 'ctl00_ContentPlaceHolder1_ddlBusState').select data['state']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusPhone').set data['phone']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusZip').set data['zip']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusTollFree').set data['tollfree']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusEmail').set data['email']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtBusWebsite').set data['website']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtUserEmail').set data['email']
rescue => e
  unless @retries == 0
    puts "Error caught in business registration: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in business registration could not be resolved. Error: #{e.inspect}"
  end

end
def finish_bregistration
@browser.button(:value => /Submit for revision/i).click

30.times{ break if @browser.status == "Done"; sleep 1}
end

#Main 
@retries = 5
add_business(data)
enter_captcha( data )
30.times{ break if @browser.status == "Done"; sleep 1}
finish_bregistration
true