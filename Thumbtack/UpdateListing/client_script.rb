sign_in(data)
@browser.goto("http://www.thumbtack.com/profile/dashboard")

@browser.link(:text => 'Edit profile').click

@browser.text_field(:name => 'sav_business_name').when_present.set data ['business']
@browser.text_field(:name => 'sav_title').set data ['title']
@browser.text_field(:name => 'sav_description').set data ['description']

@browser.link(:text => 'Save changes').click

true




