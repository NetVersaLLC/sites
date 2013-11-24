@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

@browser.goto 'http://www.patch.com/'

@browser.text_field(:id => 'zip').set '90210' #data[ 'zip' ]
@browser.button(:class => 'submit').click

@browser.wait_until do
	if @browser.text =~ /We’re not in your town quite yet, but we will be./
		return true
	elsif @browser.text =~ /We've got you covered! Here's your Patch:/
		return true
	else
		return false
	end
end

if @browser.text.include? "We’re not in your town quite yet, but we will be."
	puts "Patch not avilable for this business!"
else
	@browser.div(:class => /nearby_patches/).link(:href => /patch.com/).click
	@browser.link(:class => 'js-trackable js-needs_current_user data-tag').click
	@browser.text_field(:name => 'name').set 'John Smith'
	@browser.text_field(:name => 'email').set 'wnvta123@live.com'
	@browser.text_field(:name => 'password').set 'test123'
	@browser.text_field(:name => 'confirm_password').set 'test123'
	@browser.label(:class => 'checkbox').click
	@browser.checkbox(:id => 'subscriptions_Daily').clear
	@browser.button(:id => 'signup').click
	@browser.button(:class => 'close close_modal').click
end

true