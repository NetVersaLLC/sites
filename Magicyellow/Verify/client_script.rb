sign_in(data)

sleep(2)
Watir::Wait.until { @browser.text.include? "Your Contact Info" }

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Magicyellow'

true


