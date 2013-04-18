def search_the_business( data )

  # A) Going to home page and locating iframe with search elements - didn't work
  # @browser.goto( 'http://expressupdateusa.com/' )
  # def search_frame; @browser.frame( :src, 'https://listings.expressupdateusa.com/dashboard/searchentry?p=CheckListing:GetStarted' ) end
  # search_frame.locate

  # B) Opening the IFRAME directly - worked incorrectly - it returned not all search results
  # @browser.goto( 'https://listings.expressupdateusa.com/dashboard/searchentry?p=CheckListing:GetStarted' )

  # C) Sending url request with busines name in it
  # search_url = 'http://listings.expressupdateusa.com/Search/Results?CompanyNameFilter=' + data[ 'business_name' ] # &State=CA
  # @browser.goto( search_url )

  puts 'Searching for a business: ' + data[ 'business_name' ]
  @browser.goto( 'http://listings.expressupdateusa.com/Search' )
  @browser.text_field( :id, 'CompanyNameFilter' ).set data[ 'business_name' ]
  state = data[ 'business_state' ]
  @browser.select_list( :id, 'State' ).select state if not state.nil?
  @browser.button( :class, 'SearchButton' ).click

  def verify_link; @browser.link( :id, 'verifyLink' ) end
  Watir::Wait::until do @browser.text.include? 'Search Results' or verify_link.exists? end
  
  if @browser.text.include? 'No listings found'

    if @chained
	  self.start("Expressupdateusa/AddListing")
    end
    true
    
  else

    if not verify_link.exists?
      @browser.link( :text, 'View Full Listing' ).click
    else
      # do nothing
    end

    @business_page_url = @browser.url()
    @browser.link( :id, "verifyLink").click

    if @browser.text.include? "Thank You!"
	        puts("Business verified1")
		    true
    end


  end

end
sign_in( data )
search_the_business( data )

