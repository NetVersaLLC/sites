goto_signin_page
process_crunchbase_signin(data)

@browser.goto("http://www.crunchbase.com/companies/new")

@browser.text_field(:id => 'company_name').set data['business']
@browser.text_field(:id => 'company_description').set data['tags']
#TODO @browser.select_list(:id => 'company_category').select data['category1']
@browser.text_field(:id => 'company_homepage_url').set data['url']
@browser.select_list(:id => 'company_founded_year').select data['yearfounded']

@browser.file_field(:id => 'company_image_attributes_uploaded_data').set data['logo']
@browser.text_field(:id => 'company_overview').set data['description']
puts("Finished entering info")
enter_captcha_addbusiness

Watir::Wait.until {@browser.text.include? "Thanks for the submission." }
true
sleep(50)