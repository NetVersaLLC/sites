#Create business page
def create_list(data)
  login(data)
  if @browser.link(:text => data['business']).exist?
    @browser.link(:text => data['business']).click
  end
  @browser.text_field(:class=> 'inputtext textInput DOMControl_placeholder').set data[ 'category' ]
  @browser.text_field(:class=> 'inputtext textInput DOMControl_placeholder').send_keys :down
  @browser.text_field(:class=> 'inputtext textInput DOMControl_placeholder').send_keys :enter
  @browser.text_field(:class=> 'DOMControl_placeholder uiTextareaNoResize uiTextareaAutogrow').set data[ 'business_description' ]
  @browser.text_field(:class=> 'inputtext DOMControl_placeholder').set data[ 'website' ]
  @browser.checkbox(:id=>'u_0_5').set
  @browser.checkbox(:id=>'u_0_7').set
  @browser.button(:value=>'Save Info').click
  
    #upload image
  @browser.file_field(:id=>'u_0_d').set data['logo']
  @browser.span(:text => 'Next').when_present.click
  @browser.span(:text => 'Skip').when_present.click
  @browser.link(:text => 'Skip').when_present.click
  
  #Verify
  if @browser.span(:text => data['business']).exist?
    puts "Business page has been created successfully"
  else
    puts "There is a problem with Business page creation"
  end
end

#Main steps
login(data)
create_list(data)
true
