@browser.goto( 'https://www.showmelocal.com/Login.aspx' )
sleep 2
Watir::Wait::until {@browser.text.include? "we don't post anything on your profile"}

@browser.text_field( :id => '_ctl0_txtUserName').set data[ 'email' ]
@browser.text_field( :id => '_ctl0_txtPassword').set data[ 'password' ]
@browser.button(:name => '_ctl0:cmdLogin').click

sleep 2
Watir::Wait::until{@browser.text.include? "No Recent Activity"}
@browser.link(:text, "Add a Business").click
sleep 2
Watir::Wait::until{@browser.text.include? "Email"}

@browser.link(:id, "hlLoginLink").click
@browser.text_field(:name => '_ctl0:txtUserName').set data[ 'email' ]
@browser.text_field(:name => '_ctl0:txtPassword').set data[ 'password' ]
@browser.button(:name, "_ctl0:cmdLogin").click
sleep 2
@browser.text_field(:name => '_ctl0:txtBusinessName').set data[ 'business' ]
@browser.text_field(:name => '_ctl0:txtBusinessType').set data[ 'category' ]
@browser.text_field(:name => '_ctl0:txtPhone').set data[ 'phone' ]
if data['address'].gsub("\s","") == ""
	data['address'] = "-"
end
@browser.text_field(:name => '_ctl0:txtAddress').set data[ 'address' ]
@browser.text_field(:name => '_ctl0:txtAddress2').set data[ 'address2' ]
@browser.text_field(:name => '_ctl0:txtZip').set data[ 'zip' ]
enter_captcha( data )
@browser.button(:name, "cmdSave").click

sleep 2
puts("Please wait the script needs to be tested right after here!")
true