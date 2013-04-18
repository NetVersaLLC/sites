url = data[ 'url' ]
@browser.goto(url)

if @chained
  self.start("Insiderpages/HandleListing")
end

true
