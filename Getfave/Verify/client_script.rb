link = data['link']
@browser.goto(link)
Watir::Wait::until do
  @browser.text.include? "Log Out"
if @chained
  self.start("GetFave/CreateListing")
end
  true
end
