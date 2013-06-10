@browser = Watir::Browser.new
businessfixed        = data['business'].gsub(" ", "+")
begin
 @browser.goto("https://www.getfave.com")

sleep 2
  @browser.link(:id => 'change-location').when_present.click
  @browser.text_field(:id => 'g-text-field').set data['city'] + ", " + data['state_short']

  raise Exception, 'Internal Server Error (500)' if @browser.text.include? 'Internal Server Error (500)'

rescue Exception => e
  puts(e.inspect)
  if tries > 0
    tries -= 1
    retry
  else
    throw "Job failed due to server internal error."
  end
end


  sleep 3

  #@browser.text_field(:id => 'g-text-field').send_keys :enter
  @browser.send_keys :enter
sleep 5
@browser.goto("https://www.getfave.com/search?q=#{businessfixed}")

if @browser.text.include? "We couldn't find any matches."

  businessFound['status'] = :unlisted
else
  @browser.links(:id => /business_/).each do |resultLink|
    if resultLink.span(:class => 'name').text =~ /#{data['business']}/i
      businessFound['listed_address'] = resultLink.span(:class => 'address').text
      businessFound['listed_url'] = resultLink.href

      nok = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
      if nok.css("a#claim").length > 0
        businessFound['status'] = :listed
      else
        businessFound['status'] = :claimed
      end


      break
    end

  end

end

at_exit do @browser.close end

[true, businessFound]