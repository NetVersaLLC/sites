@browser.goto( "https://www.yellowbot.com/signin/register" )

  @browser.text_field( :id => 'reg_email' ).set data[ 'email' ]
  @browser.text_field( :id => 'reg_email_again' ).set data[ 'email' ]

  @browser.text_field( :id => 'reg_name' ).set data[ 'username' ]
  @browser.text_field( :id => 'reg_password' ).set data[ 'password' ]
  @browser.text_field( :id => 'reg_password2' ).set data[ 'password' ]
  
  @browser.checkbox( :name => 'tos' ).set
  @browser.checkbox( :name => 'opt_in' ).clear

	enter_captcha( data )
  
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'YellowBot'
  
  if @chained
	  self.start("Yellowbot/Verify")
	end
  
  
  true