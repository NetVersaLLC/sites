def search_for_business( business )

businessFound = {}
  @browser.goto( 'http://www.bing.com/businessportal/' ) 
  sleep 2
  @browser.button( :value , 'Get Started' ).when_present.click
  sleep 2
  @browser.link(:title => 'Add Your Business').when_present.click
  

  
    sleep 2
    @browser.execute_script("hidePopUp()")
    @browser.text_field(:name => 'PhoneNumber').when_present.set business['phone']
    @browser.execute_script("hidePopUp()")
    @browser.button(:value => 'Search').click
    @browser.execute_script("hidePopUp()")
    sleep 2
    Watir::Wait.until(10) { @browser.text.include? "Search Results" or @browser.text.include? "We found no businesses with the given information"}

    sleep 10

    @browser.links.each do |nk|
      next if not nk.attribute_value("title")
      next if not nk.visible?
      puts "Incoming link title:"
      puts nk.attribute_value("title")

    end

    if @browser.link(:title => /#{business['business']}/i).exists?
      businessFound['status'] = :listed
      businessFound['listed_name'] = @browser.link(:title => /#{business['business']}/i).text
      businessFound['listed_address'] = @browser.p(:xpath => '//*[@id="0"]/tbody/tr/td[2]/p[1]').text + @browser.p(:xpath => '//*[@id="0"]/tbody/tr/td[2]/p[2]').text
    else
      businessFound['status'] = :unlisted
    end
  return businessFound
end

businessFound = search_for_business(data)

[true, businessFound]