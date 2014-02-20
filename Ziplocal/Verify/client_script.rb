@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}
def main( data )
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
  else 
    if @chained 
      self.start("Ziplocal/Verify", 1440)
    end 
  end 
end 

main(data)
self.success
