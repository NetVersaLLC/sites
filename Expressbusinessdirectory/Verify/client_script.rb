@browser.goto(data['url'])

puts(data['password'])

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPassword').set data['password']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtPasswordConfirm').set data['password']

@browser.link( :id => 'ctl00_ContentPlaceHolder1_cmdSave').click

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'model' => 'Expressbusinessdirectory'

true