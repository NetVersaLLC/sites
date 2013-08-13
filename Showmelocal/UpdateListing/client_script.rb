@browser.goto('https://www.showmelocal.com/Login.aspx')
@browser.text_field( :id => '_ctl0_txtUserName').set data[ 'email' ]
@browser.text_field( :id => '_ctl0_txtPassword').set data[ 'password' ]
@browser.button(:name => '_ctl0:cmdLogin').click

sleep 2
Watir::Wait::until{@browser.text.include? "Address"}

@browser.link(:text => 'edit profile').click

sleep 2
Watir::Wait::until{@browser.text.include? "Business Information"}
@browser.button(:name, "cmdAdd").click

sleep 2
Watir::Wait::until{@browser.text.include? "Business Information"}

@browser.text_field(:name => 'txtBusinessName').set data['name']
@browser.text_field(:name => 'txtType').set data['category']
@browser.text_field(:name => '_ctl1:txtPhone1').set data['phone']
@browser.text_field(:name => '_ctl1:txtFax').set data['fax']
@browser.text_field(:name => '_ctl1:txtEmail').set data['email']
@browser.text_field(:name => '_ctl0:txtAddress1').set data['address_full']
@browser.text_field(:name => '_ctl0:txtCity').set data['city']
@browser.select_list(:name => '_ctl0:cboState').option(:value, data['state']).select
@browser.text_field(:name => '_ctl0:txtZip').set data['zip']

@browser.button(:name, "cmdAdd").click
sleep 2
Watir::Wait::until{@browser.text.include? "Business Name:"}
@browser.button(:name, "cmdDescription").click
sleep 2
Watir::Wait::until{@browser.text.include? "Description of Services"}
@browser.textarea(:name, 'txtBody').set data['desc']
@browser.button(:name, "cmdEdit").click
sleep 2
Watir::Wait::until{@browser.text.include? "Sun"}
@browser.button(:name, 'cmdBusinessHours').click
sleep 2
Watir::Wait::until{@browser.text.include? "Business Hours"}
days = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
days.each do |day|
	if data["#{day}"] == true	
		open=data["#{day}_open"].downcase.gsub("a"," a").gsub("p"," p")[1..-1]
		close=data["#{day}_close"].downcase.gsub("a"," a").gsub("p"," p")[1..-1]
		day=day.capitalize
		@browser.select_list(:name => "_ctl0:ddOpen#{day}").select open
		@browser.select_list(:name => "_ctl0:ddClose#{day}").select close
	end	
end
@browser.button(:name => '_ctl0:cmdEdit').click
sleep 2
Watir::Wait::until{@browser.text.include? "Payment Options"}
@browser.button(:name, 'cmdPaymentOptions').click
sleep 2
Watir::Wait::until{@browser.text.include? "Payment Options"}
payments = data[ 'payments' ]
payments.each do |pay|
	@browser.checkbox(:id => pay).set
end

@browser.button(:name => '_ctl0:cmdEdit').click
Watir::Wait::until{@browser.link(:id => '_ctl0_hlBusinessDashboard').exists?}
true