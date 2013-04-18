sign_in(data)
@browser.goto("http://smallbusiness.yahoo.com/dashboard/mybusinesses?brand=local")

@browser.link(:text => 'Edit').when_present.click
sleep(2)

@browser.text_field( :id => 'cfirstname' ).when_present.set data[ 'first_name' ]
  @browser.text_field( :id => 'clastname' ).set data[ 'last_name' ]
  @browser.text_field( :id => 'email' ).set data[ 'email' ]
  @browser.text_field( :id => 'phone' ).set data[ 'phone' ]

  # Business Information
  @browser.text_field( :id => 'coEmail' ).set data[ 'business_email' ]

    # .. fill all the info because its blank
    @browser.text_field( :id => 'bizname' ).set data[ 'business_name' ]
    @browser.text_field( :id => 'addr' ).set data[ 'business_address' ]
    @browser.text_field( :id => 'city' ).set data[ 'business_city' ]
    @browser.select_list( :id => 'state' ).select data[ 'business_state' ]
    @browser.text_field( :id => 'zip' ).set data[ 'business_zip' ]
    @browser.text_field( :id => 'addphone' ).set data[ 'business_phone' ]
    # TODO: add website @browser.text_field( :id => '?' ).set data[ 'business_website' ]
	@browser.text_field( :id => 'acseccat1' ).clear
	sleep(3)
    cats = CGI.unescapeHTML(data[ 'business_category' ])
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
  hours = data['hours']

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
  # @browser.text_field( :id => 'fax' ).set data[ 'fax_number' ]
  sleep(2)
  if @browser.h3( :id => 'otheroperationdetails-collapsed' ).exists?
        @browser.h3( :id => 'otheroperationdetails-collapsed' ).click

    @browser.text_field(:id => "established").set data['founded']

    data[ 'payment_methods' ].each{ | method |
            @browser.select_list( :id => 'payment' ).select method
    }

  end

@browser.button(:id => 'submitbtn').click
sleep(5)
true



