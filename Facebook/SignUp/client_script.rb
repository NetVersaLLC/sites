@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

def create_profile( data )
	@browser.text_field(:name, 'firstname').set data['first_name']
	@browser.text_field(:name, 'lastname').set data['last_name']
	@browser.text_field(:name, 'reg_email__').set data['email']
	@browser.text_field(:name, 'reg_email_confirmation__').set data['email']
	@browser.text_field(:name, 'reg_passwd__').set data['password']
	@browser.select_list(:id, 'month').select data['month']
	@browser.select_list(:id, 'day').select data['day']
	@browser.select_list(:id, 'year').select data['year']
	if data['gender'] == "Male" or data['gender'] == "Unknown"
		@browser.radio(:name => 'sex', :value => "2").set
	else
		@browser.radio(:name => 'sex', :value => "1").set
	end
	@browser.button(:text, 'Sign Up').click
end

def end_result( data )
	if @browser.button(:value =>'Find Friends').exists?
		puts("No Verification Required")
		if @chained
			self.start("Facebook/CreatePage")
		end
	elsif @browser.text.include? "Please Verify Your Identity"
		puts("Phone Verification Required")
		if @chained
			self.start("Facebook/Notify")
		end
	else
		puts("Email Verification Required")
		if @chained
	  		self.start("Facebook/Verify")
		end
	end
end

@browser.goto("https://www.facebook.com/")
create_profile( data )
@browser.img(:src, 'fbstatic-a.akamaihd.net/rsrc.php/v2/yb/r/GsNJNwuI-UM.gif').wait_while_present
self.save_account("Facebook", {:email=>data['email'],:password=>data['password']})
end_result( data )
true