def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\hotfrog_captcha.png"
  obj = @browser.image(:src, /ctl00_contentsection_captchamanager/)
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
    @browser.text_field( :id, /ctl00_contentSection_CaptchaManager_ctl00_txtCaptcha/).set captcha_code
    @browser.link(:text=> 'Submit').click
    sleep(5)
    if not @browser.text.include? "The code you typed doesn't seem to match, please try again"
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
