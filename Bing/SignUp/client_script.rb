@browser.goto('https://signup.live.com/signup.aspx?')


  @browser.execute_script("

      _d.getElementById('iFirstName').value = '#{data[ "first_name" ]}';
      _d.getElementById('iLastName').value = '#{data[ "last_name" ]}';
      _d.getElementById('iBirthMonth').value = '#{data[ "birth_month" ]}';
      _d.getElementById('iBirthDay').value = '#{data[ "birth_day" ]}';
      _d.getElementById('iBirthYear').value = '#{data[ "birth_year" ]}';
      _d.getElementById('iGender').value = 'u';


    ")

puts(data['password'])
puts(data['secret_answer'])
sleep(3)
=begin
  @browser.text_field(  :id, 'iFirstName' ).set     data[ "first_name" ]
  @browser.text_field(  :id, 'iLastName' ).set      data[ "last_name" ]
  @browser.select_list( :id, 'iBirthMonth' ).select data[ 'birth_month' ]
  @browser.select_list( :id, 'iBirthDay' ).select   data[ 'birth_day' ]
  @browser.select_list( :id, 'iBirthYear' ).select  data[ 'birth_year' ]
  @browser.select_list( :id, 'iGender' ).select     data[ 'gender' ]
=end  
  # click <get a new email address> to open alt email field
  
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
=begin
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
  email_name = data[ 'name' ].downcase.delete( ' ' ).strip + (rand( 10000 )+200).to_s #get_email_name( data )
  @browser.text_field( :id, 'imembernamelive' ).set email_name
  data[ 'hotmail' ] = email_name + '@hotmail.com'
  puts(data['hotmail'])
=end

  enter_captcha
 
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data['hotmail'], 'account[password]' => data['password'], 'account[secret_answer]' => data['secret_answer'], 'model' => 'Bing'
if @chained
		self.start("Bing/CreateRule")
end

true


  #captcha_text = solve_captcha( :sign_up )
  #@browser.text_field( :class, 'spHipNoClear hipInputText' ).set captcha_text

  # B) Alternative email name guessing loop, that tries to get available email name but it may froze
  #begin
  #
  #  @browser.text_field( :id, 'imembernamelive' ).set email_name
  #  captcha_text = solve_captcha()
  #  @browser.text_field( :class, 'spHipNoClear hipInputText' ).set captcha_text
  #  # @browser.button( :title, 'I accept' ).click
  #
  #  Watir::Wait::until do
  #    @browser.p( :id, 'iMembernameLiveError' ).exists? or @browser.link( :text, 'Continue to Hotmail' ).exists?
  #    #and @browser.p( :id, 'iMembernameLiveError' ).text.include? "@hotmail.com isn't available." )
  #  end
  #  email_name = email_name + rand( 10 ).to_s
  #
  #end until @browser.link( :text, 'Continue to Hotmail' ).exists?
  #@browser.link( :text, 'Continue to Hotmail' ).click
#
#	 #@browser.button( :title, 'I accept' ).click
  #watir_must do @browser.link( :text, 'Continue to Hotmail' ).exists? end
 
  #puts 'Hotmail account: ' + business[ 'hotmail' ] + " - " + business[ 'password' ]
  # RestClient.post "#{@host}/bing/save_hotmail?auth_token=#{@key}&business_id=#{@bid}", :email => business['hotmail'], :password => business['password'], :secret_answer => business['secret_answer']
#   # A) Simple one time email field input - if it is taken the script will fail
#    # Get a new email address
