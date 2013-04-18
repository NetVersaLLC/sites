@browser.goto(data['url'])

if @browser.text.include? "Your account was activated successfully and your subscription is now complete."
puts("listing activated")
end
