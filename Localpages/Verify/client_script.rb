self.save_account('Localpages', { :password => data['password'] })

	if @chained
		self.start("Localpages/AddListing")
	end

self.success
