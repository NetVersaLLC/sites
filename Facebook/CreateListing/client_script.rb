#Create business page
def create_list(data)

  if @browser.link(:text => data['business']).exist?
    @browser.link(:text => data['business']).click
  elsif @browser.link(:text => 'Create a Page').exists?
    create_page(data)
    sleep 10
  end
  sleep 2
  Watir::Wait.until {@browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).exists?}
  if @browser.text_field(:class=> 'inputtext textInput DOMControl_placeholder').exist?
    if @browser.link(:title => "Remove").exists?
      @browser.link(:title => "Remove").click
    end
    sleep 4
    @browser.text_field(:id => 'u_0_2').set data[ 'category' ]
    sleep 4
    @browser.send_keys :down
    @browser.send_keys :enter
  end
  

  
  @browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).click
  @browser.text_field(:class=> /uiTextareaNoResize uiTextareaAutogrow/).set data[ 'business_description' ]
  @browser.text_field(:class=> 'inputtext', :name=> 'website[]').click
  @browser.text_field(:class=> 'inputtext', :name=> 'website[]').set data[ 'website' ]
  if @browser.checkbox(:id=>'u_0_1').exists?
    @browser.checkbox(:id=>'u_0_1').set
  end
  if @browser.checkbox(:id=>'u_0_3').exists?
    @browser.checkbox(:id=>'u_0_3').set
  end
  @browser.button(:value=>'Save Info').click
  
  logo = self.logo

  if logo.nil?
    sleep 2
    @browser.span(:text => 'Skip').when_present.click
  else
    @browser.file_field(:id=>'u_0_d').when_present.set logo
    sleep 2
    @browser.span(:text => 'Next').when_present.click
  end

  sleep 2
  @browser.link(:text => 'Skip').when_present.click
  sleep 2
  @browser.link(:text => 'Skip').when_present.click
  sleep 2
  #Verify
  if @browser.span(:text => data['business']).exist?
    puts "Business page has been created successfully"
  else
    puts "There is a problem with Business page creation"
  end
end

#Main steps
begin

@browser.goto "www.facebook.com"
login(data)
create_list(data)
true

rescue Exception => e
    puts "Caught a #{e.message}"
end
