def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\business_captcha.png"
  obj = @browser.image( :xpath, "/html/body/div/div[2]/div/div/form/div[2]/dl/dt[8]/img" )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

