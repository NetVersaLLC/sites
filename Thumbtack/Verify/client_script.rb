link = data['link']
@browser.goto(link)

if @chained
  self.start("Thumbtack/CreateListing")
end
    


