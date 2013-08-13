url=data['link']
@browser.goto(url)
sleep 2
Watir::Wait::until{@browser.text.include? "Account Activation"}
@browser.text_field(:name => 'txtPassword').set data['password']
@browser.button(:text => "Activate").click
sleep 2
Watir::Wait::until{@browser.text.include? "we don't post anything on your profile"}
true