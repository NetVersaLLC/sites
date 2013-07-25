@browser.goto( "http://myaccount.zip.pro/find-business.php" )
@browser.text_field( :id => 'bzPhone').set data['phone']

@browser.button( :id => 'search_find_tel').click

@browser.link( :class => 'createList').click

@browser.text_field( :id => 'comp_name').set data[ 'business' ]
@browser.text_field( :id => 'address').set data[ 'address' ]
@browser.text_field( :id => 'addressln2').set data[ 'address2' ]
@browser.text_field( :id => 'city').set data[ 'city' ]
@browser.select_list( :id => 'zp_state_selection').select data[ 'state_name' ]
@browser.text_field( :id => 'zip').set data[ 'zip' ]
@browser.text_field( :id => 'main_phone').set data[ 'phone' ]



@browser.link( :id => 'zpPriCatPop').click
sleep 1
data['categorytree'].each_pair do |k,cat|
  next if cat == ""
  tries = 1
  begin
    sleep 3  
    if tries == 0
      sub3 = @browser.link( :text => /#{cat}/i)
      sub3.click
    else
          alink = @browser.link( :text => "#{cat}")
          alink.click
          sleep 2
          alink = alink.parent()
          alink.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click  
    end
  rescue Exception => e
    puts(e.inspect)
    if tries > 0
      tries -= 1
      retry
    else
    end
  end
end

 
  @browser.link( :id => 'zpCatMoveRight').click
  @browser.button( :id => 'zpSaveCategory').click
 

enter_captcha( data )

sleep 5

#@browser.text_field( :id => 'f_name').when_present.set data['fname']
#@browser.text_field( :id => 'l_name').set data['lname']
#@browser.text_field( :id => 'email').set data['email']
#@browser.text_field( :id => 'v_email').set data['email']
#@browser.text_field( :id => 'password').set data['password']
#@browser.text_field( :id => 'c_password').set data['password']
aretries = 3
begin
@browser.text_field( :id => 'answer').set data[ 'secretAnswer' ]
rescue
  if aretries > 0 then
    puts("Answer field not found. Retrying...")
    @browser.text_field( :name => 'answer').set data[ 'secretAnswer' ]
    retry
  else
    puts("One last try...")
    @browser.text_field( :class => 'half verticalsprite', :id => 'answer').set data[ 'secretAnswer' ]
  end
end
enter_captcha2( data )

sleep 2
Watir::Wait.until { @browser.text.include? "Verify your email address" }

if @browser.text.include? "Verify your email address"
	self.save_account("Zippro", {:username => data['email'], :password => data['password'], :secret1 => data['secretAnswer']})
	if @chained
		self.start("Zippro/Verify")
	end
	
	true
end

