@browser.goto data['url']

Watir::Wait.until { @browser.text.include? "Corporate membership information" and @browser.link(:text => 'Logout').exist? }

if @chained
  self.start("Businessdb/CreateListing")
end
true