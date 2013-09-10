sign_in data
@browser.link( :title => 'Add Business').click
30.times { break if @browser.status == "Done"; sleep 1 }

@browser.link( :xpath => '//*[@id="mainpage"]/table[1]/tbody/tr[5]/td/table/tbody/tr[1]/td[1]/table/tbody/tr[2]/td/a[3]').click
30.times { break if @browser.status == "Done"; sleep 1 }

@browser.text_field( :id => 'subfolder_name').set data['siteName']
@browser.link( :title => 'GET STARTED!').click
if @browser.alert.exists?
	@browser.alert.ok
end
30.times { break if @browser.status == "Done"; sleep 1 }

fill_contact_info data
@browser.checkbox( :name => 'agree').click
@browser.button( :value => /Next/).click
30.times { break if @browser.status == "Done"; sleep 1 }

fill_categories data
@browser.button( :value => /Next/, :index => 1).click
30.times { break if @browser.status == "Done"; sleep 1 }

@browser.button( :value => /Next/, :index => 2).click
30.times { break if @browser.status == "Done"; sleep 1 }

fill_payment_methods data
@browser.button( :value => /Next/, :index => 3).click
30.times { break if @browser.status == "Done"; sleep 1 }

fill_titles data
@browser.button( :value => /Next/, :index => 4).click
30.times { break if @browser.status == "Done"; sleep 1 }

fill_logo data
@browser.button( :value => /Next/, :index => 5).click
30.times { break if @browser.status == "Done"; sleep 1 }

@browser.button( :value => /Finish/).click
30.times { break if @browser.status == "Done"; sleep 1 }
Watir::Wait.until { @browser.text.include? "What's New at #{data['business']}" }

true