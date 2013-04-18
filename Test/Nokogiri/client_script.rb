total = 'unknown'
browser = Watir::Browser.start 'http://mtgox.com'
nok = Nokogiri::HTML( browser.html )
nok.xpath("//li[@id='highPrice']").each do |li|
  total = li.text
end
browser.close
mb = Win32API.new("user32", "MessageBox", ['i','p','p','i'], 'i')
mb.call(0, total , 'Bitcoin Price', 0)

true
