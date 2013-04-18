@browser.goto("http://www.yellowassistance.com/frmLogin.aspx")

@browser.text_field(:name , "txtFName").set data["fname"]
@browser.text_field(:name , "txtScreenName").set data["username"]
@browser.text_field(:name , "txtRegEmail").set data["email"]
@browser.text_field(:name , "txtRegConfirmEmail").set data["email"]
@browser.text_field(:name , "txtRegPassword").set data["password"]
@browser.text_field(:name , "txtRegConfirmPassword").set data["password"]
@browser.select_list(:name , "ddlSecretQuestion").select "What is your mother's maiden name?"
@browser.text_field(:name , "txtSecretAnswer").set data["secret_answer"]


@browser.img(:id => 'btnRegister').click

Watir::Wait.until { @browser.text.include? "Thank You, Here's how your information will be displayed to others." }

@browser.button(:name => 'btnS2Continue').click

Watir::Wait.until { @browser.text.include? "Check your e-mail now!" }

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['username'], 'account[password]' => data['password'], 'account[secret_answer]' => data['secret_answer'], 'model' => 'Yellowassistance'

if @chained
  self.start("Yellowassistance/Verify")
end

true

