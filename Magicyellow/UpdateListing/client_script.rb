sign_in(data)

sleep(3)
Watir::Wait.until { @browser.text.include? "Your Contact Info" }

@browser.link(:xpath => "/html/body/table/tbody/tr/td/table/tbody/tr/td/table[3]/tbody/tr/td[3]/table/tbody/tr[2]/td[2]/a").click

 @browser.text_field(:name => 'ServicesExtra').set data[ 'additional_services' ] 
  @browser.text_field(:name => 'ProductsExtra').set data[ 'additional_products' ] 
  @browser.text_field(:name => 'BrandsExtra').set data[ 'additional_brands' ] 
  
  # Add payment_options
  payments = data['payment_option']
  payments.each do |payment|  
    @browser.checkbox(:value => card_type(payment).to_s).click
  end

@browser.button(:value => 'Save').click

true