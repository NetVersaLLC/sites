url = data[ 'url' ]
@browser.goto(url)

if @chained
  self.start("Insiderpage/HandleListing")
end

true
