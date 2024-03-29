def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\mydestination_captcha.png"
  obj = @browser.image(:src, '/media/captcha.jpg')
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
    captcha_text = solve_captcha	
    @browser.text_field( :id, 'captcha').set captcha_text
    @browser.div(:class => 'ctrlHolder buttonholder').button(:type => 'submit').when_present.click
    sleep(5)
    if not @browser.text.include? "please enter the correct captcha code"
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
