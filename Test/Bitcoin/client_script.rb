total = 'unknown'
browser = Watir::Browser.start 'http://mtgox.com'
if browser.text =~ /High:\$([0-9\.]+)/i
  total = $1
end
browser.close

puts "Total: #{total}"


true
