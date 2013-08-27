# Start Sign Up process
url = 'https://register.kudzu.com/packageSelect.do'
@browser.goto(url)
30.times{ break if @browser.status == "Done"; sleep 1}
@browser.button( :name, 'basicButton' ).click

# Fill Create Your Login page
  # Watir::Wait::until @browser.text.include "Create Your Login" or assert that
  # Watir::Wait::until do @browser.text.include? "agree to the terms below" end
@browser.text_field( :id => 'userName' ).set data[ 'userName' ]
@browser.text_field( :id => 'email' ).set data[ 'email' ]
@browser.text_field( :id => 'pass1' ).set data[ 'pass' ]
@browser.text_field( :id => 'pass2' ).set data[ 'pass' ]
@browser.select_list( :id, 'securityQuestion' ).select data[ 'securityQuestion' ]
@browser.text_field( :id => 'answer' ).set data[ 'answer' ]
@browser.button( :name, 'nextButton' ).click

30.times{ break if @browser.status == "Done"; sleep 1}

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['userName'], 'account[password]' => data['pass'], 'account[secret_answer]' => data['answer'], 'model' => 'Kudzu'
if @chained
	self.start("Kudzu/CreateListing")
end
true
#Basic SignUp ends