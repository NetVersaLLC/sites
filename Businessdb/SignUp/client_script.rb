@browser.goto 'http://www.businessdb.com/sign-up'
@browser.text_field(:name => 'password_again').set data['password']
@browser.text_field(:name => 'password').set data['password']
@browser.text_field(:name => 'company_name').set data['business']
@browser.select_list(:name => 'country_id').select data['country']
@browser.text_field(:name => 'email').set data['email']
@browser.checkbox(:name => 'agreement').set
@browser.link(:text => 'Sign Up FREE').click

throw "Business registration got failed due to duplicate credentials" if @browser.text.include? "The Company name field must contain a unique value" or @browser.text.include?  "The Email field must contain a unique value."

Watir::Wait.until { @browser.link(:text => 'Logout').exist? }

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'email' ], 'account[password]' => data['password'], 'model' => 'Businessdb'

if @chained
  self.start("Businessdb/Verify")
end
true