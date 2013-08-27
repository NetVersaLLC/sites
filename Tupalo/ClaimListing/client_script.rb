@browser.goto("http://tupalo.com/en/accounts/sign_in")
30.times{ break if @browser.status == "Done"; sleep 1}

@browser.text_field(:id => "account_email").set data ['email']
@browser.text_field(:id => "account_password").set data['password']
@browser.button(:id => "spot_submit").click

30.times{ break if @browser.status == "Done"; sleep 1}

url=@browser.url+"?only=discovered_spots"
@browser.goto(url)

30.times{ break if @browser.status == "Done"; sleep 1}

@browser.span(:class => "index" ).click

30.times{ break if @browser.status == "Done"; sleep 1}

url=@browser.a(:text => /Claim your business listing/).href
@browser.goto(url)

30.times{ break if @browser.status == "Done"; sleep 1}

@browser.a(:class => /button green color/).click

30.times{ break if @browser.status == "Done"; sleep 1}

true