

@browser.goto('http://www.manta.com/profile/my-companies/select?add_driver=home-getstarted')
@browser.text_field( :name => 'email').set data['username']
@browser.text_field( :name => 'password').set data['password']
@browser.link(:text => 'Sign in').click
sleep(15) # this page always takes so long to load that Watir will timeout before it does. even Waits time out. 

@browser.link(:text => /#{data['business']}/i).click

sleep(15) #I think their web server runs on the united postal service.


#@browser.button( :class, 'get_verified_btn').click
#sleep(3)
nok = Nokogiri::HTML( @browser.html )
verifyCode = nok.xpath('//*[@id="get-verified-dialog-container-edit-existing"]/div[2]/div[2]/p[2]').inner_text
verifyCode = verifyCode.gsub(/[^0-9A-Za-z]/, '')
verifyCode = verifyCode.gsub("ReferenceCode", '')

number = nok.xpath('//*[@id="get-verified-dialog-container-edit-existing"]/div[2]/div[2]/p[1]').inner_text
number = number.gsub(/[^0-9A-Za-z]/, '')
number = number.gsub("Call", '')


puts ("Doing phone verification")
puts(number)
puts(verifyCode)
code = PhoneVerify.enter_code(number, verifyCode)

true