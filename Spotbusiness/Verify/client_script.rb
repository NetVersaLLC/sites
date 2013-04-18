#Go to the activation link
@browser.goto(data['url'])

if @browser.text.include? "Your account is now active"
  puts "Account has been activated successfully"
  true
  else
  throw("There was a problem activating the account")
end
