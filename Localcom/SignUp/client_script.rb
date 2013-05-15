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

if @browser.button(:name => 'ctl00$ContentPlaceHolder1$ctl00',:type=> 'submit').exist?
  @browser.button(:name => 'ctl00$ContentPlaceHolder1$ctl00',:type=> 'submit').click
else
  if @browser.button(:name => /ctl00\$ContentPlaceHolder1\$listings\$/,:type=> 'submit').exist?
    @browser.button(:name => /ctl00\$ContentPlaceHolder1\$listings\$/,:type=> 'submit').click
  end
end

@browser.text_field( :name => 'ctl00$ContentPlaceHolder1$primary_cat').when_present.click
sleep(5)
@cat_frame = @browser.frame(:src => "/create/dialogs/categories.aspx?focus=Category1")
@cat_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Category1').focus
@cat_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Category1').click
@cat_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Category1').when_present.set data['category1']
@cat_frame.div(:id => 'list1').div(:index => 0).when_present.click
@cat_frame.button( :name =>'ctl00$ContentPlaceHolder1$Button1').when_present.click
@browser.div( :class => 'uList point').when_present.click
sleep(5)
@desc_frame = @browser.frame(:src => "/create/dialogs/info.aspx?focus=Description")
@desc_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Description').set data['description']
@desc_frame.text_field( :name => 'ctl00$ContentPlaceHolder1$Services').set data['services']

# Select operation hours
if data['24hours'] == true
  @desc_frame.radio( :id => 'ctl00_ContentPlaceHolder1_HOOMode_1').click
else
  hours = data[ 'hours' ]
  hours.each_with_index do |hour, day|
    theday = hour[0]	
    theday = theday[0..2]
    if theday == "thu"
      theday = "thur"
    end
    if hour[1][0] != "closed"
      open = hour[1][0]
      openAMPM = open[-2, 2].upcase
      close = hour[1][1]
      closeAMPM = close[-2, 2].upcase
      if open.chars.first == "0"
        open[0] = ""
      end
      if close.chars.first == "0"
        close[0] = ""
      end
      @desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}AM").select open.gsub(" ","")
      @desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}PM").select close.gsub(" ","")
    else
      @desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}AM").select /Closed/i
      @desc_frame.select_list( :name => "ctl00$ContentPlaceHolder1$#{theday}PM").select /Closed/i
    end
  end
end

#Select Payment options
payments = data['payments']
payments.each do |pay|
  @desc_frame.checkbox( :name => "ctl00$ContentPlaceHolder1$check1$#{pay}").when_present.click
end

@desc_frame.button(:id => 'ctl00_ContentPlaceHolder1_btn').when_present.click

@browser.button(:id => 'ctl00_ContentPlaceHolder1_Button3').when_present.click

@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_register_password').when_present.set data['password']
@browser.text_field( :id => 'ctl00_ContentPlaceHolder1_register_confirm_password').when_present.set data['password']
RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'model' => 'Localcom'
@browser.button(:id => 'ctl00_ContentPlaceHolder1_button_free').click

true





