def sign_in( data )
	@browser.goto( 'http://www.listwns.com/home/index.aspx' )
	if @browser.h2(:text => 'Sign In').exists?
		@browser.text_field( :id => 'email').set data['email']
		@browser.text_field( :id => 'pw1').set data['password']
		@browser.checkbox(:id => 'remember').click
		@browser.button(:id => 'Button1').click
	else
		puts("Already logged in")
	end
end
