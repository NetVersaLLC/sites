def solve_captcha
  begin
  image = "#{ENV['USERPROFILE']}\\citation\\brownbook_captcha.png"
  obj = @browser.img(:src, /captchaimage.php/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

    return CAPTCHA.solve image, :manual
  rescue => e
    puts(e.inspect)
  end
end

def retry_captcha
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha  
    @browser.text_field(:id, 'confirm').set captcha_text
     sleep(5)
    if not @browser.text.include? "The characters you've entered don't match those in the image"
      capSolved = true
    end
    count+=1
  end
  if capSolved == true
    true
  else
    raise "Captcha could not be solved during SignUp"
  end
end