def user_registration(data)
@browser.goto( 'http://www.localndex.com/register.aspx' )
30.times{ break if @browser.status == "Done"; sleep 1}
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserName').set data ['username']
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserEmail').set data ['email']
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserPass1').set data ['password']
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserPass2').set data ['password']
rescue => e
  unless @retries == 0
    puts "Error caught in initial registration: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in initial registration could not be resolved. Error: #{e.inspect}"
  end
end
def chain_payload
if @chained
	self.start("Localndex/Verify")
end
true
end
# Global Retry Count, affects all rescues.
@retries = 5
user_registration(data)											#Sign_up form filling.
enter_captcha(data) 										#Entering the captcha.
30.times{ break if @browser.status == "Done"; sleep 1}		#Wait for page load.
chain_payload 												#Chain the subsequent payload.