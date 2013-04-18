@browser.goto( 'http://biz.yellowee.com/steps/find-your-business' )

@browser.text_field( :id => 'what' ).set data[ 'business' ]
@browser.text_field( :id => 'where' ).set data[ 'query' ]
@browser.button( :id => 'submit' ).click


@browser.button( :name => 'add_new_listing').click
#Regardless of the results above, we end up on the SignUp page next.
#After we signup we have to search again, so it doesn't matter at this point if the business exists or not.


@browser.text_field( :id => 'id_first_name' ).set data[ 'firstname' ]
@browser.text_field( :id => 'id_last_name' ).set data[ 'lastname' ]
@browser.text_field( :id => 'id_phone1' ).set data[ 'phone1' ]
@browser.text_field( :id => 'id_phone2' ).set data[ 'phone2' ]
@browser.text_field( :id => 'id_phone3' ).set data[ 'phone3' ]
@browser.text_field( :id => 'id_email' ).set data[ 'email' ]
@browser.text_field( :id => 'id_email2' ).set data[ 'email' ]
@browser.checkbox( :id => 'id_tos' ).click

enter_captcha( data )

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Yellowee'

if @chained
	self.start("Yellowee/Verify")
end

true


