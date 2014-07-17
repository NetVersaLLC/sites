@browser = Watir::Browser.new :firefox

at_exit {
  unless @browser.nil?
    @browser.close
  end
}

def coinflip
  coin = rand(100)
  if coin > 50
    return true
  else
    return false
  end
end

# Temporary methods from Shared.rb

def solve_captcha2
  begin
  image = "#{ENV['USERPROFILE']}\\citation\\bing1_captcha.png"
  obj = @browser.div(:id => 'hipLoading').img()
  #obj = @browser.img( :xpath, '//div/table/tbody/tr/td/img[1]' )
  #obj = @browser.img( :src, /https:\/\/DC\d\.client\.hip\.live\.com/)
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  sleep(3)

    return CAPTCHA.solve image, :manual
  rescue Exception => e
    puts(e.inspect)
  end
end

def enter_captcha
  5.times do
    obj = @browser.text_field(:id => /wlspispSolutionElement/).set solve_captcha2 
    @browser.button(:value => /Create account/).click

    sleep(20)

    break if @browser.url =~ /https:\/\/account.live.com\/summarypage.aspx/i
  end

  raise("Captcha could not be solved") unless @browser.url =~ /https:\/\/account.live.com\/summarypage.aspx/i
end


if data['gender'] == "Unknown" then data['gender'] = "Male" end

@browser.goto('https://signup.live.com/signup.aspx?')


retries = 3
type = ""
begin
    @browser.text_field(  :id, 'iFirstName' ).set data[ "first_name" ]
    @browser.text_field(  :id, 'iLastName' ).set data[ "last_name" ]
    @browser.select_list( :id, /iBirthMonth/ ).when_present.select_value data[ 'birth_month' ]
    @browser.select_list( :id, /iBirthDay/ ).select   data[ 'birth_day' ]
    @browser.select_list( :id, /iBirthYear/ ).select  data[ 'birth_year' ]
    @browser.select_list( :id, /iGender/ ).select     data[ 'gender' ]

    @browser.link( :id, /iliveswitch/ ).click
    sleep 4 # or wait until id => imembernamelive exists
    @browser.text_field( :id, /iAltEmail/ ).set    data[ 'alt_email' ]
    @browser.text_field( :id, /iPhone/ ).set       data[ 'mobile_phone' ]
    @browser.select_list( :id, /iCountry/ ).select data[ 'country' ]
    @browser.text_field( :id, /iZipCode/ ).set     data[ 'zip' ]
    @browser.checkbox( :id, /iOptinEmail/ ).clear
 
    @browser.text_field( :name, /iPwd/ ).set       data[ 'password' ]
    @browser.text_field( :name, /iRetypePwd/ ).set data[ 'password' ]
    # Add a smidge of randomization
    if coinflip == true
      firstname = data['first_name'].capitalize
    else
      firstname = data['first_name'].downcase
    end
    if coinflip == true
      lastname = data['last_name'].capitalize
    else
      lastname = data['last_name'].downcase
    end
    emailretries = 4
    email_name = firstname + data['last_name'].downcase
    @browser.text_field( :id, /imembernamelive/ ).set email_name
    sleep 2
    @browser.text_field( :id, /iFirstName/).click # Causes the email check to occur
    sleep 2
    @browser.text_field(  :id, 'iLastName' ).click
    sleep 2
    @browser.img(:src, /progressindicator\.gif/).wait_while_present
    until @browser.text.include? "@outlook.com is available"
      if emailretries == 1
        @var = 8.times.map{ rand(9) }.join
        email_name = data[ 'name_longer' ].downcase.delete( ' ' ).strip + @var.to_s
        @browser.text_field( :id, /imembernamelive/ ).set email_name
        sleep 2
        @browser.text_field( :id, /iFirstName/).click # Causes the email check to occur
        sleep 2
        @browser.text_field(  :id, 'iLastName' ).click
        sleep 2
        @browser.img(:src, /progressindicator\.gif/).wait_while_present
        emailretries -= 1
      elsif emailretries == 2
        @var = 4.times.map{ rand(9) }.join
        email_name = firstname + data['name'].downcase.delete( ' ' ).strip + @var.to_s
        @browser.text_field( :id, /imembernamelive/ ).set email_name
        sleep 2
        @browser.text_field( :id, /iFirstName/).click # Causes the email check to occur
        sleep 2
        @browser.text_field(  :id, 'iLastName' ).click
        sleep 2
        @browser.img(:src, /progressindicator\.gif/).wait_while_present
        emailretries -= 1
      elsif emailretries == 3
        @var = 3.times.map{ rand(9) }.join
        email_name = lastname + data['first_name'].downcase + @var.to_s
        @browser.text_field( :id, /imembernamelive/ ).set email_name
        sleep 2
        @browser.text_field( :id, /iFirstName/).click # Causes the email check to occur
        sleep 2
        @browser.text_field(  :id, 'iLastName' ).click
        sleep 2
        @browser.img(:src, /progressindicator\.gif/).wait_while_present
        emailretries -= 1
      elsif emailretries == 4
        @var = 2.times.map{ rand(9) }.join
        email_name = firstname + data['last_name'].downcase + @var.to_s
        @browser.text_field( :id, /imembernamelive/ ).set email_name
        sleep 2
        @browser.text_field( :id, /iFirstName/).click # Causes the email check to occur
        sleep 2
        @browser.text_field(  :id, 'iLastName' ).click
        sleep 2
        @browser.img(:src, /progressindicator\.gif/).wait_while_present
        emailretries -= 1
      else
        throw "Email could not be set uniquely."
      end
    end
    data[ 'hotmail' ] = email_name + '@outlook.com'


end


sleep(3)

data['email'] = data['hotmail']

enter_captcha

self.save_account('Bing',  {:email => data['email'],:password => data['password'], :status => "Account created, creating listing..."})

if @chained
  self.start("Bing/CreateRule")
end

self.success

