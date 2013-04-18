def claim_it()

  watir_must do @browser.div( :text , 'Claim' ).click end
  count = 1
  begin
    captcha_text = solve_captcha( :add_listing )
    @browser.div( :class, 'LiveUI_Area_Picture_Password_Verification' ).text_field().set captcha_text
    @browser.div( :text , 'Continue' ).click
    count += 1
    if count > 10
      raise "Too many incorrect CAPTCHA solves"
    end
  end while @browser.html =~ /Characters did not match/

  #Watir::Wait::until do
  #  @browser.div( :text, 'Ok' ).exists? # or  :class, 'Dialog_TitleContainer'
  #end
  sleep(5)
  @browser.div( :text, /OK/i ).click
  # Redirected to Business Portal - Details Page, so enter all the info as with new listing
end

sign_in( data )
search_for_business( data )
claim_it()

if @chained
  self.start("Bing/Update")
end

true
