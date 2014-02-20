@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

@browser.goto( "http://www.yellowbot.com/" )
@browser.text_field( :id => 'search-field' ).set data[ 'phone' ]
@browser.button( :value => 'Find my business' ).click 

Watir::Wait.until do 
  @browser.link( :text => 'submit a new business').exists? || 
  @browser.link( :text => 'Claim' ).exists?
end 

if @browser.link( :text => 'Claim' ).exists?
  puts("Business exists, claiming")
  if @chained
    self.start("Yellowbot/Notify")
  end
else
  if @chained
    self.start("Yellowbot/CheckCreated", 1440)
  end
end
self.success
