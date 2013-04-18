require 'tmpdir'
image = RestClient.get 'http://c.vrane.com/captcha'

captcha = "#{Dir.tmpdir}/captcha.png"

handle = open(image)
open(captcha, "wb") do |file|
      file.write handle.read
end

solution = CAPTCHA.solve captcha, 'manual'

puts "Solution: #{solution}"

true
