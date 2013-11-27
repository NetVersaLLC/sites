@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

@browser.goto('https://twitter.com/login')

@browser.text_field(:name => 'session[username_or_email]', :index => 2).when_present.set data['username']
@browser.text_field(:name => 'session[password]', :index => 2).set data['password']
@browser.button(:class => 'submit btn primary-btn').click

@browser.div(:id => 'tweet-box-mini-home-profile').when_present.focus
@browser.div(:id => 'tweet-box-mini-home-profile').send_keys data['tweet'].split("")
@browser.button(:text => 'Tweet').click
sleep 2
@browser.button(:text => 'Tweet').wait_while_present

true