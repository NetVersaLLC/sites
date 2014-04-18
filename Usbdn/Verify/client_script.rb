at_exit { @browser.close unless @browser.nil? }

@browser = Watir::Browser.new :firefox

if data['url'].nil?
  puts "No verification email found. Restarting in one day."
  self.start("Usbdn/Verify",1440) if @chained
else
  @browser.goto(data['url'])

  if @browser.text.include? "Your account was activated successfully and your subscription is now complete."
    puts("Listing activated")
  end
end