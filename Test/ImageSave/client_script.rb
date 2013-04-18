@browser = Watir::Browser.new

@browser.goto "http://www.ratemyknockers.com/"

@browser.image(:src, /\/pics\/img.*?\.jpg/).save  "C:\\Users\\jonathan\\Desktop\\knockers.jpg"
