@browser.goto("https://secure.ezlocal.com/manage/login.aspx")

@browser.text_field(:name => 'txtUsername').set data['email']
@browser.text_field(:name => 'txtPassword').set data['temp_password']

@browser.button(:name => 'btnLogin').click

Watir::Wait.until { @browser.h3(:text => 'Business Information').exists?}

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['temp_password'], 'model' => 'Ezlocal'

true