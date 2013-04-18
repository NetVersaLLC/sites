@browser.goto("https://advertise.local.com/")

@browser.text_field( :name => /first_name/).set data['fname']
@browser.text_field( :name => /last_name/).set data['lname']
@browser.text_field( :name => /title/).set data['business']
@browser.text_field( :name => /login_email/).set data['email']
@browser.text_field( :name => /phone/).set data['localphone']
@browser.text_field( :name => /street_name/).set data['address']
@browser.text_field( :name => /city/).set data['city']
@browser.select_list( :name => /state/).select data['state']
@browser.text_field( :name => /postal_code/).set data['zip']

@browser.button( :type => 'submit').click

sleep(10)

begin
  @browser.button(:name, "ctl00$ContentPlaceHolder1$listings$ctl00$ctl02").click
rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")
  sleep(1)
  #next
end


@browser.text_field( :name => 'ctl00$ContentPlaceHolder1$primary_cat').click
sleep(5)
@cat_frame = @browser.frame(:src => "/create/dialogs/categories.aspx?focus=Category1")
@cat_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Category1').focus
@cat_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Category1').click
@cat_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Category1').set data['category1']
sleep(3)
#@browser.send_keys :arrow_down
sleep(2)
@cat_frame.div(:id => 'list1').div(:index => 0).click
sleep(3)


@cat_frame.button( :name =>'ctl00$ContentPlaceHolder1$Button1').click
sleep(3)

@browser.div( :class => 'uList point').click
sleep(5)
@desc_frame = @browser.frame(:src => "/create/dialogs/info.aspx?focus=Description")
@desc_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Description').set data['description']
@desc_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Services').set data['services']





if data['24hours'] == true
puts("1")
	@desc_frame.radio( :id => 'ctl00_ContentPlaceHolder1_HOOMode_1').click
else
puts("2")
hours = data[ 'hours' ]
hours.each_with_index do |hour, day|
puts("3")

	theday = hour[0]	
	theday = theday[0..2]
  if theday == "thu"
  theday = "thur"
  end
  
  puts("ctl00$ContentPlaceHolder1$#{theday}AM")
	if hour[1][0] != "closed"
  puts("4")
		# Is the day closed?	
		open = hour[1][0]
		openAMPM = open[-2, 2].upcase
		close = hour[1][1]
    puts("5")
		closeAMPM = close[-2, 2].upcase
    if open.chars.first == "0"
      open[0] = ""
      puts("6")
    end
    if close.chars.first == "0"
      close[0] = ""
    end
		puts("7")
    @desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}AM").select open.gsub(" ","")
    
			@desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}PM").select close.gsub(" ","")
	else
  puts("8")
		@desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}AM").select /Closed/i
			@desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}PM").select /Closed/i
      puts("8.5")
	end
  puts("9")
end

end
payments = data['payments']
puts("10")
payments.each do |pay|
puts("11")
  @desc_frame.checkbox( :name => "ctl00$ContentPlaceHolder1$check1$#{pay}").click
end

@desc_frame.button(:id => 'ctl00_ContentPlaceHolder1_btn').click
sleep(3)
@browser.button(:id => 'ctl00_ContentPlaceHolder1_Button3').click
sleep(5)

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_register_password').set data['password']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_register_confirm_password').set data['password']

RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Localcom'

@browser.button(:id => 'ctl00_ContentPlaceHolder1_button_free').click

true














