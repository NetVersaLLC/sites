@browser.goto 'http://www.247onlinenetwork.com/freelistingbody.php?cityid=0'

@browser.select_list(:id => 'title_select').select 'Mr.'
@browser.text_field(:id => 'firstname').set data['firstname']
@browser.text_field(:id => 'surname').set data['lastname']
@browser.text_field(:id => 'busphone').set data['phone']
@browser.text_field(:id => 'phone').set data['altphone']
@browser.text_field(:id => 'cell').set data['mobilephone']
@browser.text_field(:id => 'tollfree').set data['tollfree']
@browser.text_field(:id => 'fax').set data['fax']
@browser.text_field(:id => 'busemail').set data['email']
@browser.button(:id => 'wizard_btnnext').click
sleep 2
30.times{ break if @browser.status == "Done"; sleep 1}

@browser.text_field(:id => 'busname').set data['business']
@browser.text_field(:id => 'address').set data['address']
@browser.text_field(:id => 'city').set data['city']
@browser.text_field(:id => 'state').set data['state']
@browser.text_field(:id => 'country').set data['country']
@browser.text_field(:id => 'zip').set data['zipcode']
@browser.text_field(:id => 'website').set data['companywebsite']
@browser.button(:id => 'wizard_btnnext').click
sleep 2
30.times{ break if @browser.status == "Done"; sleep 1}

@browser.textarea(:id => 'busdesc').set data['tagline']
@browser.textarea(:id => 'listingcontent').set data['description']
@browser.button(:id => 'wizard_btnnext').click
sleep 2
30.times{ break if @browser.status == "Done"; sleep 1}

@browser.select_list(:id => 'q2').select 'Search Engine: Google'
@browser.select_list(:id => 'q1').select 'Yes'
@browser.select_list(:id => 'q3').select 'To be found in my community'
@browser.button(:id => 'wizard_btnnext').click
@browser.button(:id => 'wizard_btnfinish').click
@browser.link(:href => 'http://www.247onlinenetwork.com/').click

sleep 2
30.times{ break if @browser.status == "Done"; sleep 1}
true