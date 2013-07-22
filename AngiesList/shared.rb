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
		sleep(2)
	end
end