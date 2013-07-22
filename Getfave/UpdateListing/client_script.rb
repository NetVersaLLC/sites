url = 'https://www.getfave.com/login'
@browser.goto url

sign_in data

queryurl = "https://www.getfave.com/search?utf8=%E2%9C%93&q=" + data['bus_name_fixed']
@browser.goto queryurl

Watir::Wait.until { @browser.div(:id => 'results').exists? }

#Update business
@browser.link(:text => 'Businesses').click
@browser.link(:text => 'Edit Information').click
fill_business data

true
