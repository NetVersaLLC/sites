#Create business page
def update_list(data)
  @browser.span(:text=> 'Edit Page').when_present.click
  @browser.span(:text=> 'Update Page Info').when_present.click  
  #Update address
  update_address(data)
  update_description(data)
  update_email(data)
  update_website(data)
end

def update_address(data)
  @browser.link(:href => /section\=address/).span(:text=> 'Edit').when_present.click
  @browser.text_field(:name=>/location__address/).when_present.set data['address']
  @browser.text_field(:name=>/location__city/).set data['city']
  @browser.text_field(:name=>/location__zip/).set data['zip']
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
end

def update_description(data)
  @browser.link(:href => /long_desc/).when_present.click
  @browser.text_field(:class=> 'uiTextareaNoResize').when_present.set data[ 'business_description' ] 
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
  sleep 2
end

def update_email(data)
  @browser.link(:href => /section\=email/).when_present.click
  @browser.text_field(:name => /email/).when_present.set data['email']
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
  sleep 2
end
  
def update_website(data)
  sleep 2
  @browser.link(:href => /section\=website/).when_present.click
  @browser.text_field(:name => /website/).when_present.set data['website']
  @browser.button(:value=>'Save Changes').click if @browser.button(:value=>'Save Changes').enabled?
  sleep 10
end


#Main steps

begin

@browser.goto "www.facebook.com"
login(data)
update_list(data)
true

rescue Exception => e
    puts "Caught a #{e.message}"
end
