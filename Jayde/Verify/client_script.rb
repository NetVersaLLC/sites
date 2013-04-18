@browser.goto(data['url'])

if @browser.text.include? "Thank You for Submitting & Confirming."

true
end