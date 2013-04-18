sign_in(data)
puts(data['category'])
@browser.goto('http://www.hyplo.com/editsite.php')

@browser.text_field( :id => 'url').when_present.set data['website']
@browser.button( :value => 'Next').click

@browser.text_field( :id => 'title').when_present.set data['title']
@browser.text_field( :id => 'description').set data['description']
@browser.select_list( :id => 'site_type_input').select data['category']
@browser.text_field( :id => 'zip').set data['zip']

#@browser.button( :value => 'Save' ).click
sleep(100)

true

