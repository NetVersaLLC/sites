@browser.goto data['url']
doc = Nokogiri::HTML(open(data['url']))
els = doc.at('body').inner_text
el   = els.first
sleep 5
if @browser.text.include? "Thank You for Submitting & Confirming."
  true
end