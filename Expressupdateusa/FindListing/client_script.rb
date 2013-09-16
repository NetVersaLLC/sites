# Retry Count
retries = 5

# Main Script
begin
  @browser.goto("http://www.expressupdate.com/search")
  @browser.text_field(:id, "query").when_present.set data['business']
  @browser.text_field(:id, "query").send_keys :enter
  Watir::Wait.until { @browser.text.include? "Here’s what we found. Please identify your business in the list below." or @browser.text.include? "Don't see your business?" }
  if @browser.span(:class => "subhead-link", :text => "#{data['business']}").exists? and @browser.span(:class => "subhead-link", :text => "#{data['business']}").parent.text.include? "(#{data['phone'][0]}) #{data['phone'][1]}-#{data['phone'][2]}"
   puts "Pre-existing listing found, proceeding to ClaimListing..."
   claimurl = @browser.span(:class => "subhead-link", :text => "#{data['business']}").parent.href
   self.save_account("Expressupdateusa", { :claimurl => claimurl })
   self.start("Expressupdateusa/Notify")
   true
  else
    if retries < 5
      self.start("Expressupdateusa/SignUp")
      true
    else
      raise "Retrying again, just to make sure." # Sometimes to search doesn't return results properly (note: rescues shouldn't normally be used to handle flow)
    end
 end
rescue => e
  unless retries == 0
    puts "Error caught while searching for business. Error: #{e.inspect}"
    puts "Retrying in two seconds. #{retries} attempts remaining."
    sleep 2
    retries -= 1
    retry
  else
    raise "Error while searching for business could not be resolved. Error: #{e.inspect}"
  end
end