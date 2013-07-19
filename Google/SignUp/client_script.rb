ENV['fname'] = data['fname']
ENV['lname'] = data['lname']
ENV['useragent'] = data['useragent']
ENV['recover_email'] = data['recover_email']
ENV['bid'] = @bid
ENV['key'] = @key
ENV['ca_file'] = "ca-bundle.crt"
ENV['phone']	= data['phone']
system "gusto.exe"