link = data['link']

@browser.goto(link)
Watir::Wait::until do
  @browser.text.include? "Your Business Has Been Added To Yelp"
end
if @browser.text.include? "Your Business Is Almost On Yelp"
  true
end
