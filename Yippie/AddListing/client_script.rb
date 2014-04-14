# Agent
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

#Methods

def submit_listing(agent, data)
	# Go to page
	page = agent.get( 'http://submit.yippie.biz/' )
	# Identify form
	form = page.form_with('frmAddBusinessListing')
	# Fill form
	form.businessname = data['business']
	form.address = data['addressComb']
	form.city = data['city']
	form.state = data['state']
	form.zipcode = data['zip']
	form.telephone1 = data['areacode']
	form.telephone2 = data['exchange']
	form.telephone3 = data['last4']
	form.website = data['website']
	form.email = data['email']
	form.field_with('categories').value = data['category1']
	# Submit form
	page = form.click_button()
	if page.body.include? "Thank you for submitting your FREE business listing to YiPpIe!"
		self.success
	else
		self.failure
	end
rescue => e
	puts e
end

# Main Controller
submit_listing(agent, data)
