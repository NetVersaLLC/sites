@browser = Watir::Browser.new

@browser.goto "http://wallbase.cc/random/"

@browser.image(:src, /\/thumbs\/.*?.jpg/).save  "C:\\Users\\jonathan\\Desktop\\thumb.jpg"
