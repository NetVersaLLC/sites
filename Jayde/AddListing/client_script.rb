@browser.goto 'http://www.jayde.com/submit-site.html'

@browser.text_field(:xpath => '//*[@id="submisstion-email-url"]/input').set data['website']
@browser.text_field(:xpath => '//*[@id="submisstion-email-input"]/input').set data['email']
@browser.text_field(:xpath => '//*[@id="id5_18_NAME_text"]/td[2]/input').set data['fullname']
@browser.text_field(:xpath => '//*[@id="id5_18_BUSINESS_NAME_text"]/td[2]/input').set data['business']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[3]/td[2]/input').set data['addressComb']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[4]/td[2]/input').set data['phone']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[5]/td[2]/input').set data['zip']

@browser.select_list(:xpath => '//*[@id="additional-info-form"]/tbody/tr[6]/td[2]/select').select data['country']
@browser.select_list(:xpath => '//*[@id="additional-info-form"]/tbody/tr[7]/td[2]/select').select data['state_name']
# @browser.select_list(:xpath => '//*[@id="additional-info-form"]/tbody/tr[8]/td[2]/select').select data['industry']
@browser.text_field(:xpath => '/html/body/div[5]/div[4]/div/form/table/tbody/tr[6]/td/table/tbody/tr[9]/td[2]/textarea').set data['description']

@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[10]/td[2]/input').set data['facebook_url']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[11]/td[2]/input').set data['google_url']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[12]/td[2]/input').set data['twitter_account']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[13]/td[2]/input').set data['twellow_account']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[14]/td[2]/input').set data['youtube_url']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[15]/td[2]/input').set data['company_logo_url']
@browser.text_field(:xpath => '//*[@id="additional-info-form"]/tbody/tr[16]/td[2]/input').set data['google_maps_url']

enter_captcha data
