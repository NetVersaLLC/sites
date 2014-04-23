# Agent
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

# Methods

def sign_up(agent, data)
	page = agent.get('http://www.localpages.com/signup/')
	form = page.form_with('signup1')
	form.username = data['username']
	form.email = data['email']
	form.radiobutton_with(:value => /business/).check
	page = form.click_button()
	if page.body.include? 'You have successfully created your profile.'
		self.save_account('Localpages', { :username => data['username'] })
		if @chained
			self.start("Localpages/Verify")
		end
	end
rescue => e
	raise e
end

# Main Controller
sign_up(agent, data)
