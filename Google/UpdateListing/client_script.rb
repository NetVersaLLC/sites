#Update listing
def update_listing(applicableLinks, data)
  puts "Selcting found business from search results."

  listIndx = applicableLinks.collect { |listing| listing[0] == data['business'] }.find_index(true)
  @browser.link(:href, applicableLinks[listIndx][1][0]).click

  puts 'Updating the busienss'
  until !!@browser.execute_script("return document.location.toString();")[/.*about/]
    sleep 3 # The url has to be the business page... wait for it... wait for it.
  end

  @browser.div(:class => 'ed9FGf').div(:text => 'Manage this page').when_present.flash
  @browser.div(:class => 'ed9FGf').div(:text => 'Manage this page').when_present.click
  sleep(5)
  if @browser.div(:class => 'au').exist? && @browser.div(:class => 'au').visible?
    @browser.checkbox(:class => 'b-U-yd').set
    @browser.div(:text => 'Okay, got it!').when_present.click
  end
  @browser.div(:text=> 'Continue and verify later').click if @browser.div(:text=> 'Continue and verify later').exist?
  edit_business(data)
  @browser.div(:text => 'Edit business information').click if @browser.div(:text => 'Edit business information').exist?
        
  #Signin if it aski
  if @browser.text_field(:id => 'Passwd').exist?
    @browser.text_field(:id => 'Passwd').set data['pass']
    @browser.button(:value, "Sign in").click
    @browser.wait()
  end
  sleep(5)	

  #Update business address
  puts "Update address"
  @browser.div(:text=> 'Address').when_present.click
  @browser.text_field(:class => 'b-Ca Qf NO').when_present.set data['address']
  @browser.text_field(:class => 'b-Ca Qf OO').when_present.set data['city']
  @browser.div(:class => "Qf aP c-v-x c-y-i-d rXcQNd-lh-la rXcQNd-lh-la-fW01td-Df1uke").when_present.click
  @browser.div(:text, "#{data['state']}").when_present.click
  @browser.text_field(:class => 'b-Ca Qf NO').when_present.set data['address']
  @browser.div(:text=> 'Save').click

  #Update Contact info
  puts "Update Contact Info"
  @browser.div(:text=> 'Contact info').when_present.click
  @browser.text_field(:class => 'b-Ca Cj tn').when_present.set data['phone']
  @browser.text_field(:class => 'b-Ca Cj vn').when_present.set data['website']
  @browser.text_field(:class => 'b-Ca Cj Fv Ma-Z-Ma').when_present.set data['email']
  @browser.div(:text=> 'Save').click

  #Update business description
  puts "Update Description"
  @browser.div(:text=> 'Description').when_present.click
  @browser.frame(:class => 'Lj editable').body(:class => 'editable').send_keys data[ 'business_introduction' ]
  @browser.div(:text=> 'Save').click
  
  #Update Photo
  puts "Update Photo"
  @browser.div(:text=> 'Photos').when_present.click
  @browser.div(:class => 'a-kb-vA').div(:class => 'c-v-x b-d b-d-nb').when_present.click
  photo_upload_pop(data)
  
  #Verify Business
  if @browser.span(:text=> 'Verify').exist?
    @browser.span(:text=> 'Verify').click
  elsif @browser.div(:text => "Verify now").exist?
    @browser.div(:text => "Verify now").click
  end

  verify_business()	
end

#Update Photo
def photo_upload_pop(data)
  require 'rautomation'
  #update logo
  if data['logo'] > 0
    photo_upload_pop = RAutomation::Window.new :title => /File Upload/
    photo_upload_pop.text_field(:class => "Edit").set(data['logo'])
    photo_upload_pop.button(:value => "&Open").click
    @browser.wait_until {@browser.div(:class => 'a-zb-xd a-S-Ea a-za-S').div(:text=> 'Upload more').exist? }
  end

  #update other images
  pic = []
  data[ 'images' ] = pic
  if pic.length > 0
    image_index = ""
    for image_index in (0..pic.length-1)
      @browser.div(:id => 'picker:ap:11').when_present.click
      photo_upload_pop = RAutomation::Window.new :title => /File Upload/
      photo_upload_pop.text_field(:class => "Edit").set(pic[image_index])
      photo_upload_pop.button(:value => "&Open").click
      @browser.wait_until {@browser.div(:class => 'a-zb-xd a-S-Ea a-za-S').div(:text=> 'Upload more').exist? }
    end
  end
  @browser.div(:class => 'c-v-x b-d b-d-nb b-d-qnnXGd-lTJzwb-rdwzAe').when_present.click
end

def edit_business(data)
  counter = -1
  if @browser.div(:class => 'Dm').exist? && @browser.div(:class => 'Dm').visible?
    @browser.divs(:class => 'Dm').each do |div|
      business = div.span(:class=> 'bC').text
      puts "Business is #{business}"
      if data[ 'business1'] == business
        counter += 1
        @browser.div(:class => 'Dm', :index => counter).div(:text => 'Edit').click
        @browser.wait_until { @browser.text.include?('Loading...') == false}
        sleep(3)
        break
      end
    end
  end
end

#Main Stpes
begin
login( data )
search_for_business( data )
discern_parse_business_exist?( parse_results(data), data )
if discern_parse_business_exist?( parse_results(data), data )
  update_listing(parse_results(data), data)
  true
end

rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")
  retry
end
