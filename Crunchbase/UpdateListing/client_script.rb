@browser.goto("http://www.crunchbase.com/login")

@browser.text_field(:id => 'username').set data['email']
@browser.text_field(:id => 'password').set data['password']

@browser.button(:value => 'Login').click

Watir::Wait.until { @browser.div(:id => 'col2_internal').exists? }

@browser.link(:xpath => '//*[@id="col2_internal"]/table/tbody/tr/td[2]/a').click

Watir::Wait.until { @browser.link(:text => 'Edit This Page').exists? }

@browser.link(:text => 'Edit This Page').click

Watir::Wait.until { @browser.text_field(:id => 'company_name').exists? }

@browser.text_field(:id => 'company_name').set data['business']
@browser.text_field(:id => 'company_description').set data['tags']
#TODO @browser.select_list(:id => 'company_category').select data['category1']
@browser.text_field(:id => 'company_homepage_url').set data['url']
@browser.select_list(:id => 'company_founded_year').select data['yearfounded']
@browser.button(:name => 'commit').click
Watir::Wait.until {@browser.text.include? "Edits submitted successfully!" }
@browser.link(:xpath => '//*[@id="col2_internal"]/h1/div/a').click
Watir::Wait.until {@browser.text_field( :id => 'company_overview').exists? }
@browser.text_field( :id => 'company_overview').set data['description']
@browser.button(:name => 'commit').click
Watir::Wait.until {@browser.text.include? "Edits submitted successfully!" }

true