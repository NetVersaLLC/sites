ENV['fname'] = data['fname']
ENV['lname'] = data['lname']
ENV['useragent'] = data['useragent']
ENV['recover_email'] = data['recover_email']
ENV['bid'] = @bid
ENV['key'] = @key
ENV['ca_cert'] = "ca-bundle.crt"
system "gusto.exe"
