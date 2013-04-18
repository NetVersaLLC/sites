link = data['link']
@browser.goto(link)
@browser.text_field( :id, 'p1' ).set data[ 'password' ]
@browser.text_field( :id, 'p2' ).set data[ 'password' ]
@browser.button( :text, 'Submit Password and Log In' ).click

if @chained
  self.start("Craig_list/SignUp")
end


