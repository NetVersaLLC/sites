@browser.goto( 'http://www.localndex.com/register.aspx' )
#Fill user details.
30.times{ break if @browser.status == "Done"; sleep 1}
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserName').set data ['username']
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserEmail').set data ['email']
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserPass1').set data ['password']
@browser.text_field(:id, 'ctl00_MainContentPlaceHolder_txtUserPass2').set data ['password']

enter_captcha(data)	#Captcha being entered here!

30.times{ break if @browser.status == "Done"; sleep 1}
if @chained
	self.start("Kudzu/CreateListing")
end
true