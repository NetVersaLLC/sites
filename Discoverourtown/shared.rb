def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\google_captcha.png"
  obj = @browser.image(:src, /recaptcha\/api\/image/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end

def enter_captcha

  capSolved = false
  count = 1
  until capSolved or count > 5 do
  captcha_code = solve_captcha
  @browser.text_field( :id, 'recaptcha_response_field').set captcha_code
  @browser.button(:value => 'Submit').click

    if not @browser.html.include?('Add Your Listing')
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
