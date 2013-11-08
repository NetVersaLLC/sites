browser.goto 'http://www.patch.com/'

browser.text_field(:id => 'zip').set '90210'
browser.button(:class => 'submit').click
browser.link(:href => 'http://beverlyhills.patch.com/').click
browser.link(:class => 'js-trackable js-needs_current_user data-tag').click
browser.text_field(:name => 'name').set 'John Smith'
browser.text_field(:name => 'email').set 'wnvta123@live.com'
browser.text_field(:name => 'password').set 'test123'
browser.text_field(:name => 'confirm_password').set 'test123'
browser.label(:class => 'checkbox').click
browser.checkbox(:id => 'subscriptions_Daily').clear
browser.button(:id => 'signup').click
browser.button(:class => 'close close_modal').click