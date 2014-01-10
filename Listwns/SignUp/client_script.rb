# #!/usr/bin/env ruby
@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def signup data
	@browser.goto 'http://www.listwns.com/home/register.aspx'
	@browser.text_field(:name=>'email').set		data['email']
	@browser.text_field(:name=>'pw1').set		data['password']
	@browser.text_field(:name=>'pw2').set		data['password']
	@browser.checkbox(:name=>'agree').set
	@browser.button(:type=>'submit').click

	if @browser.text.include? 'Join In'
		@browser.link(:text=>/Login/).click
		sleep(2)
		@browser.text_field(:name=>/user/).set 	data['email']
		@browser.text_field(:name=>/pass/).set 	data['password']
		@browser.button.click
		unless @browser.text.include? 'Logout'
			raise "Signup was unsuccessful - could not log in using registered credentials."
		end
		@browser.goto 'http://www.listwns.com/post/local.aspx'
	end

	self.save_account('Listwns',{:username=>data['email'],:password=>data['password'],:listing_url=>''})
  
	@browser.text_field(:name=>'title').set		data['business']
	@browser.text_field(:name=>'phone').set		data['phone']
	@browser.text_field(:name=>'address').set	data['address']
	@browser.select(:name=>'bztype').select		data['category']
	@browser.text_field(:name=>'city').set		data['city']
	@browser.text_field(:name=>'country').set	data['country']
	@browser.text_field(:name=>'zipcode').set	data['zip']
	@browser.text_field(:name=>'content').set	data['description']
	@browser.text_field(:name=>'tag').set		data['keywords']
	@browser.button(:type=>'submit').click

	listing_url = @browser.element(:css,'.list > h2:nth-child(1)').link.when_present.href

	self.save_account('Listwns',{:username=>data['email'],:password=>data['password'],:listing_url=>listing_url})
	true
end

signup data
# require 'mechanize'

# agent = Mechanize.new
# agent.user_agent_alias = 'Windows Mozilla'

# page = agent.get('http://www.listwns.com/home/register.aspx')
# form = page.form_with("form1")
# form.email = data['email']
# form.pw1 = data['password']
# form.pw2 = data['password']
# form.checkbox_with("agree").checked = true

# # binding.pry
# # exit
# self.save_account('Listwns', { :username => data['email'], :password => data['password']})


# page = form.click_button(form.button_with(:type => 'submit'))
# form = page.form_with("form1")
# form.title = data['business']
# form.phone = data['phone']
# form.address = data['address']
# form.bztype = data['category']
# form.city = data['city']
# form.country = data['country']
# form.zipcode = data['zip']
# form.content = data['description']
# form.tag = data['keywords']
# page = form.click_button(form.button_with(:type => 'submit'))
# true

