@browser.goto(data['url'])

enter_captcha(data)
puts "captcha has been solved"

Watir::Wait.until { @browser.text.include? "Your membership is now active!" }

if @chained
  self.start("Yellowassistance/Verify")
end

true