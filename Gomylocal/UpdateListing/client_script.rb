sign_in(data)

sleep(10) #the job breaks even with proper Waits without this sleep

@browser.link(:text => 'Edit My Listing').when_present.click
@browser.text_field(:name => 't8').when_present.set data['email']

data['logo'] == '' unless File.exist? data['logo']
if data['logo'] == ''
  @browser.checkbox(:name => 'ch2').exist?
  @browser.checkbox(:name => 'ch2').set if @browser.checkbox(:name => 'ch2').exist?
else
  @browser.file_field(:xpath => "//input[@name='f2']").set data['logo']
end

@browser.text_field(:name => 't1').set data['business']
@browser.text_field(:name => 'business_address').set data['addressComb']
@browser.text_field(:name => 't4').set data['city']
@browser.select_list(:name => 'c1').select data['state_name']
@browser.text_field(:name => 'txtZip').set data['zip']
@browser.text_field(:name => 't5').set data['phone']

@browser.text_field(:name => 't12').set data['keywords']
@browser.text_field(:name => 't9').set data['website']

@browser.text_field(:name => 'txtCategory').click
@browser.text_field(:name => 'search_txt').set data['category1']
@browser.image(:src => 'images/category_search.jpg').click
sleep(4)
@browser.frame(:name => 'Frame1').radio(:name => 'radiobutton' ).click
@browser.image(:src => 'images/category_submit.jpg').click

@browser.button(:src => '../images/update_button.jpg').click

msg = @browser.span(:class => 'orange_12pt')
if msg.exist?
  if msg.text.include? 'Successfully Updated your Listing'
    true
  else
    raise Exception, "Page filled with error - #{msg.text}" 
  end
end