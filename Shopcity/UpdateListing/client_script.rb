sign_in data
@browser.link(:text => 'My Biz').when_present.click
30.times { break if @browser.status == "Done"; sleep 1 }

@browser.link(:text => 'Contact Info').when_present.click
fill_contact_info data
@browser.link(:text => 'Save Changes').click
30.times { break if @browser.status == "Done"; sleep 1 }
Watir::Wait.until { @browser.text.include? "Your contact information was successfully updated." }
puts "Contact Info updated"

@browser.link(:text => 'Edit Profile').when_present.click
fill_titles data
@browser.link(:text => 'Save Changes').click
30.times { break if @browser.status == "Done"; sleep 1 }
Watir::Wait.until { @browser.text.include? "Your profile was successfully updated." }
puts "Profile updated"

@browser.link(:text => 'Logo/Photo').when_present.click
fill_logo data
30.times { break if @browser.status == "Done"; sleep 1 }
@browser.link(:text => 'Save Changes').click
@browser.windows.last.use
Watir::Wait.until { @browser.text.include? "Your images were successfully updated." }
@browser.window.close
@browser.windows.first.use
puts "Logo/Photo updated"

@browser.link(:text => 'Pay Methods').when_present.click
@browser.inputs(:name => "pmethods").each do |checkbox|
  checkbox.click if checkbox.attribute_value("checked") == "true"
end
fill_payment_methods data
@browser.link(:text => 'Save Changes').click
Watir::Wait.until { @browser.text.include? "Your payment methods were successfully updated." }
puts "Pay Methods updated"

@browser.link(:text => 'Categories').when_present.click
@browser.select_list(:name => "PickList").options.each do |option|
  option.click
  @browser.img(:title => 'Remove from List').click
end
fill_categories data
@browser.link(:text => 'Save Changes').click
Watir::Wait.until { @browser.text.include? "Your listing categories were successfully updated." }
puts "Categories updated"
true