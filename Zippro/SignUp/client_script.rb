puts(data[ 'category1' ] + " < " + data['parent1'] + " < " + data['root1'] + " < " + data['root21'])
#puts(data[ 'category2' ] + " < " + data['parent2'] + " < " + data['root2'] + " < " + data['root22'])


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
@browser.text_field( :id => 'comp_name').set data[ 'business' ]




@browser.link( :id => 'zpPriCatPop').click
root = @browser.link( :text => "#{data['root21']}").parent()
root.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click
sleep(1)
sub1 = @browser.link( :text => "#{data['root1']}").parent()
sub1.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click
sleep(1)
sub2 = @browser.link( :text => "#{data['parent1']}").parent()
sub2.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click
sleep(1)
sub3 = @browser.link( :text => "#{data['category1']}")
sub3.click
sleep(1)  
  
 
  @browser.link( :id => 'zpCatMoveRight').click
  @browser.button( :id => 'zpSaveCategory').click
 
 
 #second category
=begin
sleep(2)
@browser.link( :id => 'zpSecCatPop').click
 sleep(1) 
 
 @browser.divs( :class => 'hitarea hasChildren-hitarea collapsable-hitarea').reverse_each.each do |di|
 di.click
 end
 sleep(1)
 
 
 root = @browser.link( :text => "#{data['root22']}").parent()
  root.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click
sub1 = @browser.link( :text => "#{data['root2']}").parent()
  sub1.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click
sub2 = @browser.link( :text => "#{data['parent2']}").parent()
  sub2.div( :class => 'hitarea hasChildren-hitarea expandable-hitarea').click
sub3 = @browser.link( :text => "#{data['category2']}")
sub3.click
  @browser.link( :id => 'zpCatMoveRight').click
  @browser.button( :id => 'zpSaveCategory').click
=end



enter_captcha( data )

@browser.text_field( :id => 'f_name').set data['fname']
@browser.text_field( :id => 'l_name').set data['lname']
@browser.text_field( :id => 'email').set data['email']
@browser.text_field( :id => 'v_email').set data['email']
@browser.text_field( :id => 'password').set data['password']
@browser.text_field( :id => 'c_password').set data['password']

@browser.text_field( :id => 'answer').set data[ 'secretAnswer' ]

enter_captcha2( data )

Watir::Wait.until { @browser.text.include? "Verify your email address" }

if @browser.text.include? "Verify your email address"
	RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'account[password]' => data['password'], 'account[secret1]' => data['secretAnswer'], 'model' => 'Zippro'
	if @chained
		self.start("Zippro/Verify")
	end
	
	true
end


