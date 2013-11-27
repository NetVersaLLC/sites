sign_in(data)

@browser.div(:id => 'tweet-box-mini-home-profile').focus
@browser.div(:id => 'tweet-box-mini-home-profile').send_keys data['tweet'].split("")
@browser.button(:text => 'Tweet').click
sleep 2
@browser.button(:text => 'Tweet').wait_while_present

true