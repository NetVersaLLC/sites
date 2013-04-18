def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\cylex_captcha.png"
  obj = @browser.image(:src, /randomimage/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def enter_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_code = solve_captcha	
    @browser.text_field( :id, /step1_captchaTb/).set captcha_code
    @browser.button(:value => 'Next step').click
    sleep(5)
    if not @browser.text.include? "Incorrect validation code, please try again"
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
