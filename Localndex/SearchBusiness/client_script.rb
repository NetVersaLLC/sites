@browser.goto('http://www.localndex.com/claim/')
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtStartPhone1').set data['phone']
@browser.button(:id => 'ctl00_ContentPlaceHolder1_btnGetStarted1').click 

if @browser.text.include? "We couldn't find your business with the information provided."

	if @chained
		self.start("Localndex/AddBusiness")
	end	
true
elsif @browser.text.include? "Welcome"
	@browser.button( :src => 'images/localndex_promo_advtoday.png').click

	@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtEmail').set data['email']
	@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtEmail2').set data['email']
	@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']
enter_captcha2( data )
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Localndex'

end
