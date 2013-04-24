sign_in(data)

@browser.goto("http://www.usyellowpages.com")
puts("1")
@browser.link(:text => 'Manage My Account').click
puts("2")
sleep(3)
@browser.frame(:id => 'MyAccount').link(:xpath => '/html/body/span/table/tbody/tr[2]/td[3]/a').click
puts("3")
sleep(3)

@browser.window(:title => "Listing").use do

@browser.text_field(:name => 'txtBusinessName').when_present.set data['business']
@browser.text_field(:name => 'txtAddress').set data['address']
@browser.text_field(:name => 'txtZip').set data['zip']
@browser.select_list(:name => 'txtCity').focus

@browser.text_field(:id => 'FilterHeadings').set data['category']
sleep(3)
@browser.checkbox(:value => data['category']).clear
@browser.checkbox(:value => data['category']).click

@browser.text_field(:id => 'Group-0-AreaCode_0').set data['areacode']
@browser.text_field(:id => 'Group-0-Prefix_0').set data['prefix']
@browser.text_field(:id => 'Group-0-Suffix_0').set data['suffix']
@browser.text_field(:id => 'Group-0-HoursOpen_0').set data['hours']

data['payments'].each do |pay|
	@browser.checkbox(:name => pay).clear
	@browser.checkbox(:name => pay).click
end

@browser.button(:id => 'btnSubmit').click

Watir::Wait.until{@browser.text.include? "Your request to update a listing has been submitted."}


end

puts("success!")
true
