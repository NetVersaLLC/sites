require 'tmpdir'

tmpexe = "#{Dir.tmpdir}/setup.exe"

handle = open("#{@host}/downloads/#{@bid}?auth_token=#{@key}")
open(tmpexe, "wb") do |file|  
    file.write handle.read
end

system "ask.exe"
if $? == 0
  true
else
  STDERR.puts "Executing setup: #{tmpexe}"
  system tmpexe
end

true
