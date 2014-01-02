output = `glogin.exe`
output.gsub!(/^\s*/, '')
output.gsub!(/\s*$/, '')
email, password = *output.split(/\t/)
self.save_account('Google',{:email => email, :password => password})

if @chained
    self.start("Google/CreateListing")
end

true