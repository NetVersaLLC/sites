#Method for update listing

def update_business(data)
  @browser.span(:text => 'Update Listings').click
  @browser.text_field(:name=> 'visitor').set data['full_name']
  @browser.text_field( :name => 'visitormail').set data[ 'email' ]
  @browser.text_field( :name => 'phone').set data[ 'phone' ]
  @browser.text_field( :name => 'fax').set data[ 'fax' ]
  @browser.text_field( :name => 'business').set data[ 'business' ]
  @browser.text_field( :name => 'address').set data[ 'address' ]
  @browser.text_field( :name => 'city').set data[ 'city' ]
  @browser.text_field( :name => 'state').set data[ 'state' ]
  @browser.text_field( :name => 'zip').set data[ 'zip' ]
  @browser.text_field( :name => 'keyword').set data[ 'keywords' ]
  @browser.text_field( :name => 'url').set data[ 'website' ]
  @browser.text_field( :name => 'notes').set data[ 'description' ]
  @browser.select_list( :name => 'attn').select "Listing Update Request"
  @browser.text_field(:name => 'fact').set data['reason_for_update']

  enter_captcha( data )

  if @browser.text.include? "Your Listing Update Request has been received successfully..."
    puts "Listing Update is successfully"
    else
      throw ("Initial Registration is unsuccessfull")
  end
end

#Main update steps
@url = 'http://www.yellowbrowser.com/'
@browser.goto(@url)
update_business(data)
