@browser.goto( 'http://www.jayde.com/submit-site.html' )

@browser.text_field( :xpath => '//*[@id="submisstion-email-url"]/input').when_present.set data['website']
@browser.text_field( :xpath => '//*[@id="submisstion-email-input"]/input').set data['email']
@browser.text_field( :xpath => '//*[@id="id5_18_NAME_text"]/td[2]/input').set data['fullname']
@browser.text_field( :xpath => '//*[@id="id5_18_BUSINESS_NAME_text"]/td[2]/input').set data['business']
@browser.text_field( :xpath => '//*[@id="additional-info-form"]/tbody/tr[3]/td[2]/input').set data['addressComb']
@browser.text_field( :xpath => '//*[@id="additional-info-form"]/tbody/tr[4]/td[2]/input').set data['phone']
@browser.text_field( :xpath => '//*[@id="additional-info-form"]/tbody/tr[5]/td[2]/input').set data['zip']
@browser.select_list( :xpath => '//*[@id="additional-info-form"]/tbody/tr[6]/td[2]/select').select data['country']
@browser.select_list( :xpath => '//*[@id="additional-info-form"]/tbody/tr[7]/td[2]/select').select data['state_name']
@browser.text_field( :xpath => '/html/body/div[5]/div[4]/div/form/table/tbody/tr[6]/td/table/tbody/tr[9]/td[2]/textarea').set data['description']

enter_captcha( data )


