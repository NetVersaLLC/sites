# Agent
agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

# Error Classes
class NotSignedIn < StandardError
end

# Methods

def sign_in(agent, data)
	page = agent.get('http://www.localpages.com/signup/')
	form = page.form_with('login')
	form.username = data['username']
	form.password = data['password']
	page = form.click_button()
	if page.body.include? "My Dashboard"
		# Login Successful
	else
		raise "Failed to Login"
	end
end

def add_business(agent, data)
	page = agent.get('http://www.localpages.com/add_edit_business_info.php')
	unless page.body.include? "Please login to access this page."
		form = page.form_with('business_profile')
		form.business_name = data['business']
		form.field_with('category_1').value = data['category1']
		form.field_with('category_2').value = data['category2']
		form.address_1 = data['address']
		form.address_2 = data['address2']
		form.city = data['city']
		form.field_with('state').value = data['state']
		form.zip = data['zip']
		form.phone = data['phone']
		form.website = data['website']
		if not self.logo.nil? then
			form.file_uploads.find{ |upload| upload =~ /photo1/ }.file_name = self.logo
		end
		page = form.click_button(form.button_with(:text => /Save Changes/))
		if page.body.include? "Your Business is added successfully."
			self.success
		else
			self.failure("Page after submission did not contain success text")
		end
	else
		sign_in(agent, data)
		raise NotSignedIn
	end
rescue NotSignedIn
	retry
end

# Main Controller
sign_in(agent, data)
add_business(agent, data)
