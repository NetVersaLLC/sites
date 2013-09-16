# Retry Count
retries = 5

# Main Script
begin
 @browser.goto(data['claimurl'])
 @browser.link(:text, "YES, CLAIM THIS BUSINESS").when_present.click
 @browser.button(:text, "YES, CALL ME NOW").click
 Watir::Wait.until { @browser.text.include? "When prompted, please enter the following code" }
 code = @browser.div(:class => "bigtext code", :text => /\d\d\d\d/).text
 puts(code)
 PhoneVerify.send_code("expressupdateusa", code)
 sleep 10
 if @browser.text.include? "Call was not completed. Please try again."
 	raise "Call was not completed. Please try again."
 end
rescue => e
  unless retries == 0
    puts "Error caught while claiming business. Error: #{e.inspect}"
    puts "Retrying in two seconds. #{retries} attempts remaining."
    sleep 2
    retries -= 1
    retry
  else
    raise "Error while claiming business could not be resolved. Error: #{e.inspect}"
  end
end