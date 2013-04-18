def listing_already_exists

  #@claim_business_link = @browser.div( :text , 'Claim' )
  #@not_found_text = @browser.div( :class, 'LiveUI_Area_NoMatches' )
  def claim_business_link; @browser.div( :text, 'Claim' ) end
  def not_found_text; @browser.text.include? 'NO MATCHES FOUND' end

  # if claim check is first and no results found it waits for 30 seconds and fails
  watir_must do not_found_text or claim_business_link.exists? end

  if not_found_text
    puts 'No results found'
    return false
  elsif claim_business_link.exists?
    puts 'Found business named ' + @browser.div( :class, 'LiveUI_Area_Business_Details' ).text
    return true
  else
    raise StandardError.new( 'Invalid condition after business search!' )
  end
  
end

sign_in( data )
search_for_business( data )
result = listing_already_exists()

if result == true
  self.start("Bing/ClaimListing")
else
  self.start("Bing/CreateListing")
end

true
