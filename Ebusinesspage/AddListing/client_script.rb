sign_in(data)

@browser.goto( 'http://ebusinesspages.com/AddCompany.aspx' )

retries = 5
begin
  @browser.text_field( :id => 'stitle').when_present.set data['business']
  @browser.text_field( :id => 'sstreet').set data['addressComb']
  @browser.text_field( :id => 'szip').set data['zip']
  @browser.text_field( :id => 'sphone').set data['phone']
  @browser.text_field( :id => 'sfax').set data['fax']
  @browser.text_field( :id => 'semail').set data['email']
  @browser.text_field( :id => 'surl').set data['website']

  if @browser.text_field( :id => 'sCatKey').exists?
    @browser.text_field( :id => 'sCatKey').set data['category1']
    @browser.button( :id => 'CatButton').click
    sleep(2)
	30.times { break if (begin @browser.link(:text => "#{data['category1']}").present? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
    @browser.link(:text => "#{data['category1']}").click #Replaced back slash with double quotes otherwise it will fail for this category "Auto Machine Shop Equip, Supls (Whol)"
    sleep(1)
  end
  @browser.button( :id => 'CoButton').click

  if @browser.text.include?("Update successful!")
    puts "Initial Business registration is successful"
  else
    throw "Initial Business registration is unsuccessful"
  end

  # Edit Description  
  @browser.link(:id => 'bEditDescriptionButton').when_present.click
  @browser.textarea(:id => 'sdescription').when_present.set data['business_description']
  @browser.button(:value => 'Submit').click
  # Edit Logo  
  data['logo'] = self.logo
  @browser.span(:id => 'LogoText').when_present.click
  if not data['logo'].nil?
		@browser.file_field(:id => 'filUpload').when_present.set data['logo']	
  end
  sleep(3)

rescue Timeout::Error  => e
  puts(e.inspect)
  if retries > 0
    puts("Something went wrong, trying again in 2 seconds..")
    sleep 2
    retries -= 1
    retry
  end
end

if @browser.text.include? "Update successful!"
	true
end
