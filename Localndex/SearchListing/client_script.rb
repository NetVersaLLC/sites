@browser.goto('http://www.localndex.com/claim/')
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_txtStartPhone1').set data['phone']
@browser.button(:id => 'ctl00_ContentPlaceHolder1_btnGetStarted1').click 
Watir::Wait.until { @browser.span(:id => 'ctl00_ContentPlaceHolder1_lblBusNameHead2').exists? or @browser.text.include? "We couldn't find your business with the information provided" } 

if @browser.text.include? "We couldn't find your business with the information provided."

  businessFound = [:unlisted]

true
elsif @browser.text.include? "Welcome"

  @browser.button( :src => 'images/localndex_promo_advtoday.png').click

  Watir::Wait.until { @browser.text.include? "This is the information we found for the business" } 
  
  thelink = @browser.link( :id => 'ctl00_ContentPlaceHolder1_lnkProfilePage2').attribute_value("href")
  @browser.goto(thelink)
  
  Watir::Wait.until { @browser.div( :id => 'panBusiness').exists? }
  
    if @browser.link( :id => 'lnkBusLogo').exists?
        businessFound = [:listed, :unclaimed]
    else
        businessFound = [:listed, :claimed]
    end
        
end



[true, businessFound]
