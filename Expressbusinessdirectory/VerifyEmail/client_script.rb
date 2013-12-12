@browser = Watir::Browser.new :firefox

at_exit do
  unless @browser.nil?
  @browser.close
  end
end

@browser.goto(data['url2'])

Watir::Wait.until{ @browser.text.include? "Thanks! You have successfully verified your Business Email!" }

true
