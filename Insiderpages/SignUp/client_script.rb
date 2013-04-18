@browser.goto('http://www.insiderpages.com/session/new')

@browser.text_field( :id, 'friend_first_name' ).set data[ 'firstname' ]
@browser.text_field( :id, 'friend_last_name' ).set data[ 'lastname' ]
@browser.text_field( :id, 'friend_zip_code' ).set data[ 'zip' ]
@browser.text_field( :id, 'friend_email' ).set data[ 'email' ]
@browser.text_field( :id, 'friend_password' ).set data[ 'password' ]
@browser.text_field( :id, 'friend_password_confirmation' ).set data[ 'password' ]
@browser.button( :value, 'join' ).click

if @browser.text.include? "Please log into the email that you used to sign up for your account. You will receive a link from Insider Pages to confirm your email account."

puts( 'Signup complete, verify email.' )

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'InsiderPage'

if @chained
  self.start("Insiderpages/Verify")
end
true

end

