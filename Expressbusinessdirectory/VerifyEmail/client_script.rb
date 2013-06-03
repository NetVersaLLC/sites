
@browser.goto(data['url2'])

Watir::Wait.until{ @browser.text.include? "Thanks! You have successfully verified your Business Email!" }

true