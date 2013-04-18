puts(data['password'])


RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'], 'model' => 'Staylocal'

    if @chained
      self.start("Staylocal/AddListing")
    end

true