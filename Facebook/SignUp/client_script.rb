

def sign_up(data)
  @browser.link(:text=> 'Create a new business account').when_present.click
  @browser.text_field(:id =>'alogin_reg_email').set data['email']
  @browser.text_field(:id =>'reg_passwd__').set data['password']
  @browser.select_list(:id =>'birthday_month').select data['birth_month']
  @browser.select_list(:id =>'birthday_day').select data['birth_day']
  @browser.select_list(:id =>'birthday_year').select data['birth_year']
  @browser.checkbox(:id =>'terms').set
  retry_captcha(data)
  
  sleep 2
  Watir::Wait.until{@browser.text.include?('Confirm Your Email Address')}

  if @browser.text.include?('Confirm Your Email Address')
    puts "Initial Registration is successful"
    #RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'account[password]' => data['password'], 'model' => 'Facebook'
    self.save_account("Facebook", {:email=>data['email'],:password=>data['password']})
    else
    puts "Inital Registration is Unsuccessful"
  end
end

#Main Steps
@browser.goto "https://www.facebook.com/business/build"
create_page(data)
sign_up(data)

if @chained
  self.start("Facebook/Verify")
end
true
