def clean_time( time )
	time = time.gsub(":", ".")
	time = time.gsub(/(.{5})/, '\1 ')
	time
end

def loading_wait()
	if @browser.div(:class, /UpdateProgress/).visible?
	    while @browser.div(:class, /UpdateProgress/).visible?
	    	sleep(1)
	    end
	else
		5.times { break if (begin @browser.div(:class, /UpdateProgress/).visible? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
		until not @browser.div(:class, /UpdateProgress/).visible?
			sleep(1)
		end
	end
end