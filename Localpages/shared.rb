def sign_in( data )
	@browser.goto('http://www.localpages.com/signup/')
@browser.execute_script("
			oFormObject = document.forms['login'];
			oFormObject.elements['username'].value = '#{data['username']}';
			oFormObject.elements['password'].value = '#{data['password']}';		
			")

@browser.link( :text => 'Login').click

end
