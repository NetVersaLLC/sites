def add_business(data)
  @browser.div(:id => 'footer').link(:text => 'Add Your Business').click
  @browser.text_field(:name => 'contactName').set data[ 'full_name' ]	
  @browser.text_field(:name => 'companyName').set data[ 'business' ]
  @browser.text_field(:name => 'telephone').set data[ 'phone' ]
  @browser.text_field(:name => 'contactEmail').set data[ 'email' ]
  @browser.text_field(:name => 'businessType').set data[ 'category' ]
  @browser.text_field(:name => 'address').set data[ 'address' ]
  
  # Enter Captcha code
  enter_captcha(data)

  #Check for error
  @error_msg = @browser.div(:id => 'error')
  @success_msg = @browser.div(:id => 'success')

  #Check for confirmation
  @success_text = 'Thanks for filling out our contact form. Someone will be in touch soon. Please expect a reply within 24 hours.'
  if @error_msg.exist?
    throw "Initial Business registration is Unsuccessful and saying #{@error_msg.text}"
  elsif @success_msg.exist? && @success_msg.text.include?(@success_text)
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['email'], 'model' => 'Mydestination'
    puts "Initial Business registration is Unsuccessful"
  end
end

#~ #Main Steps
#~ # Launch browser

@browser.goto('http://www.mydestination.com')
browser.link(:text=> "#{data[ 'continent' ] }").click
@browser.div(:class => 'boxholder onescroll').link(:text=> "#{data[ 'country' ] }").click
@browser.div(:class => 'boxholder onescroll').link(:text=> "#{data[ 'city' ] }").when_present.click

# Add new business
add_business(data)
