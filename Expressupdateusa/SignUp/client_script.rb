

def sign_up( data )

  # assert url starts with 'https://listings.expressupdateusa.com/Account/Register'
  puts 'Signing up with email: ' + data[ 'personal_email' ]

  @browser.text_field( :id, 'Email' ).set data[ 'personal_email' ] # Password entered during Captcha
  @browser.text_field( :id, 'Phone' ).set data[ 'business_phone' ]
  @browser.text_field( :id, 'BusinessName' ).set data[ 'business_name' ]
  @browser.text_field( :id, 'FirstName' ).set data[ 'personal_firstname' ]
  @browser.text_field( :id, 'LastName' ).set data[ 'personal_lastname' ]
  
  @browser.select_list( :id, 'State' ).select data[ 'business_state' ]
  @browser.checkbox( :id, 'DoesAcceptTerms' ).set

enter_captcha( data )

  # If no return URl then 'Thank You for Registering with Express Update. An activation email sent!'

self.save_account("Expressupdateusa", { :email => data['personal_email'], :password => data['password']})


if @chained
	  self.start("Expressupdateusa/Verify")
end


true 
end


@browser.goto('https://listings.expressupdateusa.com/Account/Register')
sign_up( data )
true
