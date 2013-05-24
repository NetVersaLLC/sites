url = "http://www.getfave.com/search?q=#{data['businessfixed']}&g=#{data['cityfixed']}%2C%20#{data['state_short']}"

tries = 5
begin
  @browser.goto url
  raise Exception, 'Internal Server Error (500)' if @browser.text.include? 'Internal Server Error (500)'

rescue Exception => e
  puts(e.inspect)
  if tries > 0
    puts "Retrying in 3 seconds..."
    sleep 3
    tries -= 1
    retry
  else
    throw "Job failed due to server internal error."
  end
end

if @browser.div(:id => 'business-results').exist?
  @browser.a(:class => 'business result').click
  businessFound = [:listed]
else
  businessFound = [:unlisted]
end

[true, businessFound]