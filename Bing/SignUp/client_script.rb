puts data

@browser.goto('https://signup.live.com/signup.aspx?')


retries = 3
type = ""
begin

  case type

    #Use raw javascript to enter the fields
  when "javascript"
    @browser.execute_script("
      _d.getElementById('iFirstName').value = '#{data[ "first_name" ]}';
      _d.getElementById('iLastName').value = '#{data[ "last_name" ]}';
      _d.getElementById('iBirthMonth').value = '#{data[ "birth_month" ]}';
      _d.getElementById('iBirthDay').value = '#{data[ "birth_day" ]}';
      _d.getElementById('iBirthYear').value = '#{data[ "birth_year" ]}';
      _d.getElementById('iGender').value = 'u';
    ")

    @browser.execute_script("
      jQuery('#iliveswitch').trigger('click')
    ")
    sleep(4)

    @browser.execute_script("
      jQuery('#iqsaswitch').trigger('click')
    ")
    sleep(4)
    @browser.execute_script("
      _d.getElementById('iSQ').value = 'Name of first pet'
      _d.getElementById('iAltEmail').value = '#{data[ "alt_email" ]}';
      _d.getElementById('iSA').value = '#{data[ "secret_answer" ]}';
      _d.getElementById('iCountry').value = '#{data[ "country" ]}';
      _d.getElementById('iZipCode').value = '#{data["zip"]}';
      _d.getElementById('iOptinEmail').checked = false;

      _d.getElementById('iPwd').value = '#{data[ "password" ]}';
      _d.getElementById('iRetypePwd').value = '#{data[ "password" ]}';
    ")
  
    email_name = data[ 'name' ].downcase.delete( ' ' ).strip + (rand( 10000 )+200).to_s #get_email_name( data )

    @browser.execute_script("
      _d.getElementById('imembernamelive').value = '#{email_name}';
    ")

    data[ 'hotmail' ] = email_name + '@outlook.com'
    puts(data['hotmail'])
  
    

  else
    @browser.text_field(  :id, 'iFirstName' ).set data[ "first_name" ]
    @browser.text_field(  :id, 'iLastName' ).set data[ "last_name" ]
    @browser.select_list( :id, 'iBirthMonth' ).when_present.select_value data[ 'birth_month' ]
    @browser.select_list( :id, 'iBirthDay' ).select   data[ 'birth_day' ]
    @browser.select_list( :id, 'iBirthYear' ).select  data[ 'birth_year' ]
    @browser.select_list( :id, 'iGender' ).select     data[ 'gender' ]
    # click <get a new email address> to open alt email field
    @browser.link( :id, 'iliveswitch' ).click
    sleep 4 # or wait until id => imembernamelive exists
    # Choose a security question
    @browser.link( :id, 'iqsaswitch' ).click
    sleep 4 # or wait until id => iSA exists
    @browser.select_list( :id, 'iSQ' ).select      'Name of first pet'
    @browser.text_field( :id, 'iAltEmail' ).set    data[ 'alt_email' ]
    @browser.text_field( :id, 'iSA' ).set          data[ 'secret_answer' ]
    @browser.select_list( :id, 'iCountry' ).select data[ 'country' ]
    @browser.text_field( :id, 'iZipCode' ).set     data[ 'zip' ]
    @browser.checkbox( :id, 'iOptinEmail' ).clear
 
    @browser.text_field( :name, 'iPwd' ).set       data[ 'password' ]
    @browser.text_field( :name, 'iRetypePwd' ).set data[ 'password' ]
    email_name = data[ 'name' ].downcase.delete( ' ' ).strip + (rand( 10000 )+200).to_s
    @browser.text_field( :id, 'imembernamelive' ).set email_name
    data[ 'hotmail' ] = email_name + '@hotmail.com'
  end

  

rescue Selenium::WebDriver::Error::ElementNotVisibleError
   if retries > 0
    puts("Watir cannot find the element, trying again in 3 seconds. #{retries} remaining.")
    sleep 3
    retries -= 1
    retry
  else
    puts("Watir cannot find the element, switching to Javascript.")
    type = "javascript"
    retries = 3
    retry
  end

rescue Selenium::WebDriver::Error::JavascriptError
  if retries > 0
    puts("The javascript failed, trying again in 3 seconds. #{retries} remaining.")
    sleep 3
    retries -= 1
    retry
  else
    puts("The javascript failed and we are out of options.")
  end


rescue Exception => e
    puts "Caught a #{e.class}"
  if retries > 0
    puts("Unhandled error: #{e.class}")
    puts("Trying again in 3 seconds.")
    sleep 3
    retries -= 1
    retry
  else
    throw("Job has failed with an unhandled error: #{e.class}")
  end

end


sleep(3)

puts data['hotmail']
puts data['password']

enter_captcha

    Watir::Wait.until { @browser.text.include? "Account summary" }
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['hotmail'], 'account[password]' => data['password'], 'account[secret_answer]' => data['secret_answer'], 'model' => 'Bing'
    if @chained
  		self.start("Bing/CreateRule")
    end
    true

