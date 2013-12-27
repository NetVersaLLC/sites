@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

def solve_verify_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\facebook_captcha.png"
  if @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/).exists?
    obj = @browser.image(:src, /facebook.com\/captcha\/tfbimage.php/)
  elsif @browser.image(:src, /recaptcha\/api\/image/).exists?
    obj = @browser.image(:src, /recaptcha\/api\/image/)
  else
    throw "A wild new captcha appears!"
  end
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def retry_verify_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_verify_captcha
    @browser.text_field(:name=> 'captcha_response').when_present.set captcha_text
    @browser.button(:name =>'submit[Submit]').click

     sleep(5)
    if not @browser.text.include? "The text you entered didn't match the security check. Please try again."
      capSolved = true
    end
    count+=1
   end
  if capSolved == true
    true
  else
  throw("Captcha was not solved")
  end
end

=begin
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
    #self.save_account("Facebook", {:email=>data['email'],:password=>data['password']})
    else
    puts "Inital Registration is Unsuccessful"
  end
end
=end

#Create business page
def create_list(data)

  #if @browser.link(:text => data['business']).exist?
  #  @browser.link(:text => data['business']).click
  #elsif @browser.link(:text => 'Create a Page').exists?
  #  create_page(data)
  #  sleep 10
  #end
  sleep 2
  Watir::Wait.until {@browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).exists?}
  if @browser.text_field(:class=> 'inputtext textInput DOMControl_placeholder').exist?
    if @browser.link(:title => "Remove").exists?
      @browser.link(:title => "Remove").click
    end
    sleep 4
    @browser.text_field(:id => 'u_0_2').click
    @browser.text_field(:id => 'u_0_2').set data[ 'category' ]
    sleep 4
    #@browser.send_keys :down
    @browser.send_keys :enter
  end
  
website_unavailable = false
begin
  @browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).click
  @browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).set data[ 'business_description' ]
  @browser.text_field(:class=> 'inputtext', :name=> 'website[]').click
  if website_unavailable == true
    # Do nothing
  else
    @browser.text_field(:class=> 'inputtext', :name=> 'website[]').set data[ 'website' ]
  end
  if @browser.checkbox(:id=>'u_0_1').exists?
    @browser.checkbox(:id=>'u_0_1').set
  end
  if @browser.checkbox(:id=>'u_0_3').exists?
    @browser.checkbox(:id=>'u_0_3').set
  end
  @browser.text_field(:value, "Enter an address for your Page ...").set data['fb_url']
  @browser.button(:value=>'Save Info').click
  sleep(3)
  if @browser.text.include? "Web address is not available. Please try another one."
    raise "Website not available"
  end
rescue
	puts("Website not available. Nullifying...")
    website_unavailable = true
    @browser.text_field(:class=> 'inputtext', :name=> 'website[]').click
    @browser.text_field(:class=> 'inputtext', :name=> 'website[]').set ""
    @browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).click
    #@browser.refresh # Cannot edit the data properly without refresh, FB bug?
    @browser.button(:value=>'Save Info').click
	retry
end
  
  logo = self.logo

  if logo.nil?
    sleep 2
    @browser.span(:text => 'Skip').when_present.click
  else
    @browser.file_field(:id=>'u_0_d').when_present.set logo
    sleep 2
    @browser.span(:text => 'Next').when_present.click
  end

  sleep 2
  @browser.link(:text => 'Skip').when_present.click
  sleep 2
  @browser.link(:text => 'Skip').when_present.click
  sleep 2
  #Verify
  if @browser.span(:text => data['business']).exist?
    puts "Business page has been created successfully"
  else
    puts "There is a problem with Business page creation"
  end
end

#Main Steps
@browser.goto "https://www.facebook.com/business/build"
login(data)
create_page(data)
sleep(2)
if @browser.text.include? "Enter the text below"
    retry_verify_captcha(data)
  #Thank you for completing security checkpoint (finish this)
end
create_list(data)
true