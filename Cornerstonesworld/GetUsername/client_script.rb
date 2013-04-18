username = data['username']

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => username, 'model' => 'Cornerstonesworld'

puts("username saved")
true
