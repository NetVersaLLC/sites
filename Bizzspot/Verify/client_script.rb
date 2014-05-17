eval(data['payload_framework'])
class Verify < PayloadFramework
	def run
		if data[:url].nil?
			chain 'Verify', 1440
		else
			browser.goto data[:url]
			enter :password
			enter :password_confirmation, data[:password]
			submit
			wait_until { browser.text.include? "Password successfully updated" }
		end
	end

	def verify; true; end

	def setup_elements
		@elements[:main] = {
			:password => '#customer_password',
			:password_confirmation => '#customer_password_confirmation',
			:submit => '[name=commit]'
		}
	end
end

Verify.new('Bizzspot',data,self).verify