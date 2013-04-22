@browser.goto(data['url'])

Watir::Wait.until { @browser.text.include? "Get access to millions of company information, search by industries, products, services and locations!" }

true