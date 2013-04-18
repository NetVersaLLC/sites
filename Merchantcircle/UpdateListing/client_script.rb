sign_in(data)

@browser.goto("http://www.merchantcircle.com/merchant/edit")

@browser.text_field(:id, "name").set data['name']
@browser.text_field(:id, "telephone").set data['phone']
@browser.text_field(:id, "address").set data['address']
@browser.text_field(:name, "address2").set data['address2']
@browser.text_field(:id, "zip").set data['zip']
@browser.select_list(:name => 'state').select data['state']
@browser.text_field(:id, "url").set data['url']

@browser.text_field(:id, "tags").set data['keywords']

data[ 'payment_methods' ].each{ | method |
    @browser.checkbox( :name => method ).set
  }

@browser.button(:name => 'updateListing').click
sleep(3)

@browser.goto("http://www.merchantcircle.com/merchant/category")

data['thecategories'].each_pair do |name,cat|
	@browser.select_list(:id => name).option(:text => /#{cat}/i).click
	sleep(2)
end

@browser.button(:id=>'add').click

@browser.goto("http://www.merchantcircle.com/merchant/category")

sleep(2) # let all the javascript load.

cats = data['thecategories']
@browser.select_list(:id => 'levelone').option(:text => /#{cats['levelone']}/i).click
sleep(3)
@browser.select_list(:id => 'leveltwo').option(:text => /#{cats['leveltwo']}/i).click
sleep(3)
if cats['levelthree']
	@browser.select_list(:id => 'levelthree').option(:text => /#{cats['levelthree']}/i).click
end

@browser.button(:id=>'add').click

true
