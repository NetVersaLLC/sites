require 'cgi'

def goto_sign_up
  puts 'Business is not found - Sign up for new account'
  @browser.goto( 'http://listings.local.yahoo.com/' )
  @browser.link( :text => 'Sign Up' ).click
end

def provide_business_info( business )
  # Provide Your Business Information
  @browser.text_field( :id => 'cfirstname' ).set business[ 'first_name' ]
  @browser.text_field( :id => 'clastname' ).set business[ 'last_name' ]
  @browser.text_field( :id => 'email' ).set business[ 'email' ]
  @browser.text_field( :id => 'phone' ).set business[ 'phone' ]

  # Business Information
  @browser.text_field( :id => 'coEmail' ).set business[ 'business_email' ]
 
 

    # .. fill all the info because its blank
    @browser.text_field( :id => 'bizname' ).set business[ 'business_name' ]
    @browser.text_field( :id => 'addr' ).set business[ 'business_address' ]
    @browser.text_field( :id => 'city' ).set business[ 'business_city' ]
    @browser.select_list( :id => 'state' ).select business[ 'business_state' ]
    @browser.text_field( :id => 'zip' ).set business[ 'business_zip' ]
    @browser.text_field( :id => 'addphone' ).set business[ 'business_phone' ]
    # TODO: add website @browser.text_field( :id => '?' ).set business[ 'business_website' ]

    cats = CGI.unescapeHTML(business[ 'business_category' ])
      cats = cats.split("")
    cats.each do |cat|
      @browser.text_field( :id => 'acseccat1' ).send_keys cat
    end      
    sleep 5
    @browser.p( :class => 'autocomplete-row-margins' ).click
    #@browser.div( :id => 'add-category-row-1' ).click # add the category to test it

    @browser.button( :id => 'submitbtn' ).click

    puts("before wait")
    sleep(3)
    Watir::Wait::until do @browser.text.include? 'Optional Business Information' end
      puts("after wait")


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

def main( business )
  sign_in(business)

  goto_sign_up
  provide_business_info( business )
  preview_and_submit( business )
end

main(data)

true
