link = data['link']

@browser.goto(link)

if @browser.link(:text =>'Logout').exist?
  puts "Mail verification is successfull"
else
  puts "Main verification got some error"
end

if @chained
  self.start("Facebook/CreateListing")
end

