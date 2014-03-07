@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

def set_category( data )
	@browser.button( :id, 'listingForm:addTest2' ).fire_event("onClick")

	#wait until category text field loads
	Watir::Wait.until { @browser.text_field( :id, 'listingForm:newSic1').present? }

	#focus the field so we can get the javascript happy
	@browser.text_field( :id, 'listingForm:newSic1').focus
	@browser.text_field( :id, 'listingForm:newSic1').set data[ 'categoryKeyword' ]

	@browser.button( :value, 'Add new').wait_until_present
	@browser.button( :value, 'Add new').click
	sleep(3)	
end

def verify_listing(data)
  @browser.goto('http://www.ziplocal.com/#rl')
  @browser.span(:id => "rlTab").wait_until_present

  @browser.text_field( :id => 'tel_rl').set data[ 'phone' ]
  @browser.form(:id => 'form_rl').link(:class => 'submit_link').click

  10.times do 
    break if @browser.link(:class => "url").exist? 
    break if @browser.div(:id => "content_container_white").exist?
    sleep(1)
  end 

  if @browser.link(:class => "url").exist?
    @browser.link(:class => "url").click

    @browser.link(:text => /Update/).wait_until_present
    self.save_account("Ziplocal",{:listing_url => @browser.url})
    true
  else 
    false
  end 
end

def update_listing( data )
  @browser.goto('http://www.ziplocal.com/#rl')
  @browser.span(:id => "rlTab").wait_until_present

  @browser.text_field( :id => 'tel_rl').set data[ 'phone' ]
  @browser.form(:id => 'form_rl').link(:class => 'submit_link').click

  10.times do 
    break if @browser.link(:class => "url").exist? 
    break if @browser.div(:id => "content_container_white").exist?
    sleep(1)
  end 

  if @browser.link(:class => "url").exist?
    @browser.link(:class => "url").click

    @browser.link(:text => /Update/).wait_until_present
    self.save_account("Ziplocal",{:listing_url => @browser.url})

    @browser.link(:text => /Update/).click

    @browser.link(:text => /Update or add more information/).wait_until_present
    @browser.link(:text => /Update or add more information/).click
  else
    @browser.goto "http://www.ziplocal.com/olc/edit_listing.faces"
  end

  @browser.text_field( :id, 'listingForm:disp').when_present.set data[ 'business' ]

  if @browser.text_field( :id, 'listingForm:StrAdr').exist?
    @browser.text_field( :id, 'listingForm:StrAdr').set data[ 'streetnumber' ]
    @browser.text_field( :id, 'listingForm:city').set data[ 'citystate' ]
    @browser.text_field( :id, 'listingForm:zip').set data[ 'zip' ]
  end

  @browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
  @browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
  @browser.text_field( :id, 'listingForm:_id154').set data[ 'first_name' ] + ' ' + data[ 'last_name' ] 
  @browser.text_field( :id, 'listingForm:_id159').set data[ 'email' ]
  @browser.radio( :value, 'O').set
  @browser.text_field(:id, "listingForm:_id157").set data['prefix'] 
  @browser.link( :text, 'Save').click

  if @browser.text.include? "We apologize but your order can not be submitted"
    false
  else
    Watir::Wait.until { @browser.text.include? "Thank you for updating our directory." }
    true
  end 
end

@heap = JSON.parse( data['heap'] ) 

@heap['listing_updated'] = update_listing(data)
self.save_account("Ziplocal", {"heap" => @heap.to_json})

if @heap['listing_updated'] && !@heap['listing_verified'] 
  @heap['listing_verified'] = verify_listing(data) 
  self.save_account("Ziplocal", {"heap" => @heap.to_json})
end 

unless heap['listing_updated'] && @heap['listing_verified']
  self.start("Ziplocal/UpdateListing", 1440)
end 

self.success

