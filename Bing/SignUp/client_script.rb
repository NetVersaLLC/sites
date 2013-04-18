def get_email_name( business )
  business[ 'name' ].downcase.delete( ' ' ).strip + (rand( 10000 )+200).to_s
end

def sign_up( business )
  @browser.text_field(  :id, 'iFirstName' ).set     business[ "first_name" ]
  @browser.text_field(  :id, 'iLastName' ).set      business[ "last_name" ]
  @browser.select_list( :id, 'iBirthMonth' ).select business[ 'birth_month' ]
  @browser.select_list( :id, 'iBirthDay' ).select   business[ 'birth_day' ]
  @browser.select_list( :id, 'iBirthYear' ).select  business[ 'birth_year' ]
  @browser.select_list( :id, 'iGender' ).select     business[ 'gender' ]
  # click <get a new email address> to open alt email field
  @browser.link( :id, 'iliveswitch' ).click
  sleep 4 # or wait until id => imembernamelive exists
  # Choose a security question
  @browser.link( :id, 'iqsaswitch' ).click
  sleep 4 # or wait until id => iSA exists
  @browser.select_list( :id, 'iSQ' ).select      'Name of first pet'
  @browser.text_field( :id, 'iAltEmail' ).set    business[ 'alt_email' ]
  @browser.text_field( :id, 'iSA' ).set          business[ 'secret_answer' ]
  @browser.select_list( :id, 'iCountry' ).select business[ 'country' ]
  @browser.text_field( :id, 'iZipCode' ).set     business[ 'zip' ]
  @browser.checkbox( :id, 'iOptinEmail' ).clear
 
  @browser.text_field( :name, 'iPwd' ).set       business[ 'password' ]
  @browser.text_field( :name, 'iRetypePwd' ).set business[ 'password' ]
  email_name = get_email_name( business )
  @browser.text_field( :id, 'imembernamelive' ).set email_name
  business[ 'hotmail' ] = email_name + '@hotmail.com'
  enter_captcha
 
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => business['hotmail'], 'account[password]' => business['password'], 'account[secret_answer]' => business['secret_answer'], 'model' => 'Bing'

 end
puts("before goto")	 

@browser.goto('https://signup.live.com/')
sign_up( data )

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
