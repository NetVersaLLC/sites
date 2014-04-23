unless data['password'].nil?
	self.save_account('Localpages', { :password => data['password'] })

		if @chained
			self.start("Localpages/AddListing")
		end

	self.success
else
	self.start("Localpages/Verify", 1440)
end
