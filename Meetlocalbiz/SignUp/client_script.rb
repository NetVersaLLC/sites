@browser.goto 'http://meetlocalbiz.com/join/biz/plan/'

@browser.text_field(:id => 'name_first').set data['firstname']
@browser.text_field(:id => 'name_last').set data['lastname']
@browser.text_field(:id => 'biz_name').set data['business']
@browser.select_list(:id => 'category_id').option(:text => /#{data['category'].strip}/i).click
@browser.text_field(:id => 'street1').set data['address']
@browser.text_field(:id => 'street2').set data['address2']
@browser.text_field(:id => 'city').set data['city']
@browser.select_list(:id => 'state').select data['state']
@browser.text_field(:id => 'zip').set data['zip']
@browser.text_field(:id => 'phone').set data['phone']
@browser.text_field(:id => 'email').set data['email']
@browser.text_field(:id => 'username').set data['username']
@browser.text_field(:id => 'password').set data['password']
@browser.text_field(:id => 'password_c').set data['password']

@browser.checkbox(:id => 'tos').set
@browser.button(:id => 'joinsubmit').click

self.save_account("Meetlocalbiz", {:username => data['username'], :password => data['password']})

sleep 2
30.times{ break if @browser.status == "Done"; sleep 1}

@browser.link(:text => /Continue Next Step/).click

sleep 2
30.times{ break if @browser.status == "Done"; sleep 1}

true

