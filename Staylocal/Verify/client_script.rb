puts(data['password'].to_s)


RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[password]' => data['password'].to_s, 'model' => 'Staylocal'

    if @chained
      self.start("Staylocal/AddListing")
    end

true