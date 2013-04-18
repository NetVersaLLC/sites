def clean_time( time )
	time = time.gsub(":", ".")
	time = time.gsub(/(.{5})/, '\1 ')
	time
end
