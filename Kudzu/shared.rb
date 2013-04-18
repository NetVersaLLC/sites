#class Kudzu

#    include HTTParty
#    format :json
#    base_uri "http://cite.netversa.com"
#    debug_output

#    def self.notify_of_join( key )
#        get( "/kudzus/check_email.json?auth_token=#{key}" )
#    end

#end


def sign_in(data)

	@browser.goto("https://register.kudzu.com/login.do")		

	@browser.text_field(:name => 'username').set data['username']
	@browser.text_field(:name => 'password').set data['password']

	@browser.button(:name => 'login').click

end
