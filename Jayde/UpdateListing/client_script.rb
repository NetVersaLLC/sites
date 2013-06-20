@browser.goto 'http://www.jayde.com/'

data['business'] = 'Amazon.co.uk: Low Prices in Electronics, Books, Sports Equipment & more'

@browser.text_field(:name => 'q').set data['business']
@browser.button(:name => 'search').click

throw 'Business listing not found.' unless @browser.text.include? data['business']

@browser.link(:text => data['business']).parent.link(:text => "Edit this Listing").click

# FIXME
# Will work with webdriver 2.32
# Watir::Wait.until { @browser.text.include? "Use The Email Verification Process" }

sleep 3
@browser.link(:text => "Use The Email Verification Process").click
sleep 2
@browser.text_field(:name => 'NEW_EMAIL').set data['email']
@browser.button(:name => 'submit').click

# TODO
# Jayde needs to confirm thay you are owner of website.
# To confirm this you need to upload html file to you website,
# or you need to add metatag to homepage
# or you need to add blogpost with provided code.