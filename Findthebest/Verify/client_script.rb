@browser.goto(data['url'])

Watir::Wait.until {@browser.text.include? "You have successfully validated your e-mail address." }

true
