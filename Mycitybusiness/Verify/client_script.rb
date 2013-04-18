@browser.goto(data['url'])

if @browser.text.include? "Thank you for adding your business to mycityBusiness.net."
true
end
