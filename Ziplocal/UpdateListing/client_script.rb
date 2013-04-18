#Funtion for update listing

def update_listing(data)
  @browser.link(:text => 'Update Listings').click
  @browser.text_field(:name => 'lookupForm:tel').set data['phone']
  @browser.div(:class=> 'button_search').click
  if @browser.div(:id=> 'content_container_solid').text.include?(data['business'])
    puts "Yes business is there"
    @browser.div(:id=> 'content_container_solid').link(:text => data['business']).click
    @browser.link(:text => 'Update or add more information').click
    @browser.text_field( :id, 'listingForm:disp').set data[ 'business' ]
    @browser.text_field( :id, 'listingForm:web').set data[ 'website' ]
    @browser.text_field( :id, 'listingForm:email').set data[ 'business_email' ]
    @browser.button( :id, 'listingForm:addTest2' ).click
    @browser.wait_until {@browser.text_field(:id => 'listingForm:newSic1').exist?}
    @browser.text_field( :id=>'listingForm:newSic1').set data[ 'categoryKeyword' ]
    @browser.text_field( :xpath=> '/html/body[2]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/div[3]/div/div/table/tbody/tr/td[2]/input').set data[ 'first_name' ] + ' ' + data[ 'last_name' ]
    @browser.text_field( :xpath=> '/html/body[2]/form/table/tbody/tr[2]/td/table/tbody/tr[2]/td/div[3]/div/div/table/tbody/tr[2]/td[2]/input').set data[ 'business_email' ]
    @browser.radio( :value=> 'O').set
    @browser.link( :text, 'Save').click
        if @browser.text.include? 'Thank you for updating our directory. Updates take effect within 3 business days.'
           puts('Business added successfully')
        end
  end
end

#Main steps
url= "http://www.ziplocal.com/"
@browser.goto(url)
update_listing(data)

