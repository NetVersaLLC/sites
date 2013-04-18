link = data['link']
@browser.goto(link)
Watir::Wait::until do
  @browser.text.include? "Log Out"
if @chained
  self.start("Getfave/CreateListing")
end
  true
end
