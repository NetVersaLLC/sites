link = data['link']

@browser.goto(link)

Watir::Wait::until do
  @browser.text.include? "Thanks for Submitting your Business to Yelp"
end

true
