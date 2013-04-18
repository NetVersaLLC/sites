goto_signin_page 
process_tupalo_signin(data)
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'model' => 'Tupalo'
true