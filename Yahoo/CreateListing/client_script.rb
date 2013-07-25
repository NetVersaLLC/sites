require 'cgi'



def goto_sign_up(data)
  @browser.goto( 'http://smallbusiness.yahoo.com/local-listings/basic-listing/' )
  sleep 2
  @browser.link( :text => 'Sign up now' ).when_present.click
  #sleep 2
  #@browser.text_field(:id, 'username').when_present.set data['email']
  #@browser.text_field(:id, 'passwd').set data['password']
  sleep 4
  #@browser.button(:id, '.save').click

end


def preview_and_submit( business )
  puts 'Preview and close'
  @browser.button( :id => 'preview-bottom-btn' ).click
  sleep 10
  Watir::Wait::until do @browser.button( :id => 'prcloser' ).exists? end
  @browser.button( :id => 'prcloser' ).click

  # require "deathbycaptcha"
  puts 'Submit the business'
sleep(2)
retry_captcha2(business)
sleep(2)

Watir::Wait.until { @browser.text.include? 'Congratulations' }

  if @browser.text.include? 'Congratulations' # 'Pending Verification', 'Get a Verification Code'
    puts 'Congratulations, Yahoo! Local Listing Id: ' + @browser.label( :id => 'lc-listIdLabel' ).text
  else
    raise StandardError.new( "Problem to submit the business info!" )
  end
end

def provide_business_info( business )
  # Provide Your Business Information
  @browser.text_field( :id => 'bizname' ).set business[ 'business_name' ]
  @browser.text_field( :id => 'addr' ).set business[ 'business_address' ]
   #@browser.text_field( :id => 'city' ).set business[ 'business_city' ]
   #@browser.select_list( :id => 'state' ).select business[ 'business_state' ]
  @browser.text_field( :id => 'zip' ).set business[ 'business_zip' ]
  @browser.text_field( :id => 'phone' ).set business[ 'business_phone' ]
  @browser.text_field(:id => 'acseccat1').set business['business_category']
  sleep 2
  Watir::Wait.until{@browser.li(:text => /#{business['business_category']}/).exists?}
  @browser.li(:text => /#{business['business_category']}/).click

  sleep 2
  @browser.button(:id => 'scannow').click
  sleep 2
  @browser.button(:id => 'not-listed-button').when_present.click

  sleep 2
  @browser.checkbox(:id => 'atc').click
  sleep 2
  @browser.button(:id => 'submitbtn').click

  sleep 2

  @browser.radio(:id => 'opt-phone').when_present.click
  sleep 2
  @browser.button(:id => 'btn-phone').when_present.click
  code = PhoneVerify.retrieve_code("Yahoo")
  @browser.text_field(:id => 'txtCaptcha').set code
  sleep 4
  @browser.button(:id => 'btnverifychannel').click
  sleep 5

  if @browser.text.include? "The verification code you submitted was incorrect. Please enter the new verification code."
    throw "Phone code was incorrect"
  end

sleep 2
Watir::Wait.until {@browser.text.include? "Your Yahoo! Marketing Dashboard is ready for you to use, and your business information is being reviewed by Yahoo! Local."}

true
#preview_and_submit(business)
  
=begin
  @browser.text_field( :id => 'cfirstname' ).when_present.set business[ 'first_name' ]
  @browser.text_field( :id => 'clastname' ).set business[ 'last_name' ]
  @browser.text_field( :id => 'email' ).set business[ 'email' ]
  @browser.text_field( :id => 'phone' ).set business[ 'phone' ]

  # Business Information
  @browser.text_field( :id => 'coEmail' ).set business[ 'business_email' ]
 
 

    # .. fill all the info because its blank
    # TODO: add website @browser.text_field( :id => '?' ).set business[ 'business_website' ]

    
      @browser.text_field( :id => 'acseccat1' ).send_keys business[ 'business_category' ]
      
    sleep 2  
    Watir::Wait.until { @browser.p( :class => 'autocomplete-row-margins' ).exists? }
    @browser.send_keys :enter
    #@browser.div( :id => 'add-category-row-1' ).click # add the category to test it

    @browser.button( :id => 'submitbtn' ).click

    sleep(3)
    Watir::Wait::until do @browser.text.include? 'Optional Business Information' end
=end



end
=begin
  # Optional Business Information
  @browser.h3( :id => 'operationhours-collapsed' ).click
  sleep(2)
  @browser.radio(:id => 'hoo-detailed').click
sleep(2)
  hours = business['hours']

  hours.each_pair do |thing, thang|

    #puts(thing + " " + thang)

    theday = thing[0..2]
    if thang.to_s == "closed"
      @browser.select_list(:id => theday+'0').select "Closed"
      @browser.select_list(:id => theday+'1').select "Closed"
    else

        openHour = thang['open']
        closeHour = thang['close']
        if openHour[0,1] == "0"
          openHour = openHour[1..-1]
        end
        if closeHour[0,1] == "0"
          closeHour = closeHour[1..-1]
        end     

      @browser.select_list(:id => theday+'0').select openHour
      @browser.select_list(:id => theday+'1').select closeHour

    end
  end


  # Primary Category and details
  # @browser.text_field( :id => 'fax' ).set business[ 'fax_number' ]
  sleep(2)
  if @browser.h3( :id => 'otheroperationdetails-collapsed' ).exists?
        @browser.h3( :id => 'otheroperationdetails-collapsed' ).click

    @browser.text_field(:id => "established").set business['founded']

    business[ 'payment_methods' ].each{ | method |
            @browser.select_list( :id => 'payment' ).select method
    }

  end
end

=end

def main( business )
  sign_in(business)

  goto_sign_up(business)
  provide_business_info( business )
end

main(data)

true
