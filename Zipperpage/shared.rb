def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\zipperpage_captcha.png"
  obj = @browser.image(:src=> /image.php/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha( data )

  capSolved = false
  count = 1
  until capSolved or count > 5 do
  captcha_code = solve_captcha	
  @browser.text_field( :name, 'get_sign_crypt').set captcha_code
  @browser.button(:src => /final-design2.png/).click
  sleep(4)
  if not @browser.text.include? "Enter the Right Word on The Access Code Below"
    capSolved = true
  end	
  count+=1
  end
  if capSolved == true
    true
  else
  throw("Captcha was not solved")
  end
end


