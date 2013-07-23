
@browser.goto(data['url'])

Watir::Wait.until{ @browser.text.include? "Your account has already been activated. Please sign in." }

true