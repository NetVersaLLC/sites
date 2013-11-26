@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}


def search_for_business( business )
  retries = 3
  begin
  @browser.goto( 'http://www.bing.com/businessportal/' ) 
  sleep 2
  @browser.button( :value , 'Get Started' ).when_present.click
  sleep 2
  #@browser.link(:title => 'Add Your Business').when_present.click

  @businessfound = false


    
    sleep 2
    @browser.execute_script("hidePopUp()")
    @browser.text_field(:name => 'PhoneNumber').when_present.set business['local_phone']
    @browser.execute_script("hidePopUp()")
    @browser.button(:value => 'Search').click
    @browser.execute_script("hidePopUp()")

    sleep 2
    Watir::Wait.until(10) { @browser.text.include? "Search Results" or @browser.text.include? "We found no businesses with the given information"}
   
    if @browser.text.include? "Search Results"
      @browser.link(:href => /http:\/\/www.bing.com\/local\/details.aspx/i).each do |item|
        if item.text =~ /#{business['business']}/i
          @businessfound = true
        end
      end 

    else
      @businessfound = false
    end
  

  rescue Watir::Wait::TimeoutError
      
    if retries > 0
      @browser.execute_script("hidePopUp()") #If the Script Error popup comes up this closes it.
      puts("Something went wrong, refreshing the page and trying again.")
      @browser.refresh
      retries -= 1
      retry
    end
  rescue Exception => e
    puts(e.inspect)
  end


  return @businessfound
end


if search_for_business( data )
  self.start("Bing/ClaimListing")
else
  self.start("Bing/CreateListing")
end

true
