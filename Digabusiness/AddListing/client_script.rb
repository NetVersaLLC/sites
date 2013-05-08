sign_in(data)

sleep 2
@browser.goto('http://www.digabusiness.com/submit.php')

@browser.radio( :id => 'LINK_TYPE_NORMAL').click
@browser.text_field( :name => 'TITLE').set data['business']
@browser.text_field( :name => 'URL').set data['website']
@browser.text_field( :name => 'DESCRIPTION').set data['description']
@browser.text_field( :name => 'OWNER_NAME').set data['fullname']
@browser.text_field( :name => 'OWNER_EMAIL').set data['email']
@browser.text_field( :name => 'ADDRESS').set data['addressComb']
@browser.text_field( :name => 'CITY').set data['city']
@browser.text_field( :name => 'STATE').set data['state_name']
@browser.text_field( :name => 'ZIP').set data['zip']
@browser.text_field( :name => 'PHONE_NUMBER').set data['phone']

payments = data['payments']
payments.each do |pay|
	@browser.checkbox( :id => /#{pay}/i).click
end
retries = 4

#category selector. Retries if there is a failue. 
begin
	@browser.span( :id => 'toggleCategTree').click
	sleep(7 - retries)
	@browser.div( :title => data[ 'category1' ]).click
	sleep(7 - retries)
	@browser.div( :title => data[ 'category2' ]).click
	sleep(7 - retries)
rescue Exception => e
	puts(e.inspect)

	if retries > 0
		@browser.execute_script("reload_categ_tree(0);")
		puts("Something went wrong selecting the category.. Retrying..")
		@browser.text_field(:name => 'ADDRESS').focus
		sleep 3
		retries -= 1
		retry
	else
		puts("Unable to correct select a category. Selecting default category")
		@browser.div(:title => 'Computer Businesses').click
		sleep 5
		@browser.div(:title => 'Software Businesses').click

	end

end


enter_captcha( data )
sleep 2
Watir::Wait.until { @browser.text.include? "We got your submission!"}
true