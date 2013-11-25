def signup (data)
  tries ||= 5
  puts "data"
  if data['url'].empty?#arbitrary
  	puts "chained"
    if @chained
      self.start("Nsphere/Verify", 1440)
    end
    true
  end
  puts "goto"
  @browser.goto(data['url'])
  puts "wait"
end
=begin
  Watir::Wait.until { @browser.text.include? /Your account has now been activated./i }
rescue => e
	if (tries -= 1) > 0
		puts "Nsphere/Verify failed. Retrying #{tries} more times."
		puts "Details: #{e.message}"
		sleep 2
		retry
	else
		puts "Nsphere/Verify failed. Out of retries. Rescheduling in one day."
		self.start("Nsphere/Verify",1440)
		raise e
	end
else
	puts "Nsphere/Verify succeeded!"
	true
end
=end

@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

signup data