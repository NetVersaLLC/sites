goto_signin_page
process_crunchbase_signin(data)

@browser.goto("http://www.crunchbase.com/companies/new")

browser.text_field(:id => 'company_name').set data['business']
browser.text_field(:id => 'company_description').set data['description']
browser.select_list(:id => 'company_category').select data['category']
browser.text_field(:id => 'company_phone_number').set data['phone']
browser.text_field(:id => 'company_email_address').set data['email']
# Because of new HTML 5 security specifications, IE8 - IE9 does not reveal the real local path of the file you have selected. You have to manually change the code
browser.file_field(:id => 'company_image_attributes_uploaded_data').set data['logo']
browser.textarea(:id => 'company_overview').set data['overview']
browser.select_list(:id => 'company_founded_month').select 'January' # Remove?
browser.select_list(:id => 'company_founded_day').select '1'		 # Remove?
browser.select_list(:id => 'company_founded_year').select data['yearfounded']
browser.text_field(:id => 'tag_input').set data['tags']

solve_captcha
enter_captcha

browser.button(:name => 'commit').click
puts("Finished entering info")
enter_captcha_addbusiness

Watir::Wait.until {@browser.text.include? "Thanks for the submission." }
true
sleep(50)

# :text => 'There were problems with your submission