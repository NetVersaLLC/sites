@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

@browser.goto 'http://www.patch.com/'

@browser.text_field(:id => 'zip').set '90210' #data[ 'zip' ]
@browser.button(:class => 'submit').click

# Watir::Wait.until { @browser.text.include? ("We’re not in your town quite yet, but we will be." or "We've got you covered! Here's your Patch:") }

if @browser.text.include? "We’re not in your town quite yet, but we will be."
	puts "Patch not avilable for this business!"
else
	# @browser.div(:class => "response").div.link.click
	@browser.link(:xpath,'/html/body/div/div/div/div[2]/div/div[2]/a').click
	@browser.link(:class => 'js-trackable js-needs_current_user data-tag').click
	@browser.text_field(:name => 'name').set data['name']#'John Smith'
        @browser.text_field(:xpath ,'/html/body/div[3]/div[2]/div[2]/form/div[2]/div/input').set data['email']#'wnvta123@live.com'

	@browser.text_field(:xpath => '/html/body/div[3]/div[2]/div[2]/form/div[3]/div/input').set data['password'] #'test123'

	@browser.text_field(:xpath => '/html/body/div[3]/div[2]/div[2]/form/div[4]/div/input').set data['password']#'test123'

	# @browser.label(:class => 'checkbox').click
	@browser.checkbox(:id => 'subscriptions_Daily').clear
	@browser.button(:id => 'signup').click
	@browser.button(:xpath => '/html/body/div[3]/div/div[2]/button').click

end

true
