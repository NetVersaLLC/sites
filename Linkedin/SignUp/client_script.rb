goto_signup_page
process_linkedin_signup(data)

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Linkedin'

sleep(3)

@browser.link( :text, /Send a confirmation email instead/).click

if @chained
  self.start("Linkedin/Verify")
end

true

