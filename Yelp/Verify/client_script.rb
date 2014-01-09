@browser = Watir::Browser.new :firefox
at_exit do
    unless @browser.nil?
        @browser.close
    end
end

link = data['link']

if link.nil?
    self.start("Yelp/Verify", 1440)
    self.success("Could not find e-mail, trying again in 24 hours")
else
    @browser.goto(link)
    Watir::Wait.until do
        @browser.text.include? "Thanks for Submitting your Business to Yelp"
    end
    begin
        @browser.link(:id, /new_biz_link/).when_present.click
    rescue
        puts "Business already verified."
    end
    url = @browser.url
    self.save_account("Yelp", {:listing_url => url})
    self.success("Job completed successfully")
end
