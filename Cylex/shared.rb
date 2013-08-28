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
    @browser.text_field(:id => /step1_captchaTb/).set captcha_code
    sleep 10
    @browser.text_field(:name => /companypass1/).set data['password']
    @browser.text_field(:name => /companypass2/).set data['password']
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
    throw "Captcha was not solved"
  end
end

def fill_map_routing(data)
  @browser.link(:text => /Company details/).click
  @browser.text_field(:name => /companyname/).set data['business']
  @browser.text_field(:name => /companystreet/).set data['address']
  @browser.text_field(:name => /companycity/).set data['city']
  sleep(4)
  @browser.link(:xpath => '//*[@id="ctl00_bodyadmin"]/ul[2]/li/a').when_present.click
  @browser.text_field(:name => /postnr/).set data['zip']
  @browser.text_field(:name => /companyweb/).set data['website']
  @browser.text_field(:name => /companymail/).set data['email']
  @browser.text_field(:name => /companyphone/).set data['phone']
  unless self.logo.nil? 
    @browser.file_field(:name => /FileUpload1/).set self.logo
    @browser.button(:value => "Upload").click
  else
    @browser.file_field(:name => /FileUpload1/).set self.images.first unless self.images.empty?
    @browser.button(:value => "Upload").click
  end

  @browser.button(:value => "Save changes").click
  30.times { break if @browser.text.include? "Saving was successful."; sleep 1 }
  @browser.link(:id => /home/).click
end

def fill_description(data)
  @browser.link(:text => /Description/).click

  @browser.textarea(:name => /tb_keywords/).when_present.set data['keywords']
  @browser.textarea(:name => /tb_shortdesc/).set data['business_description']
  @browser.button(:value => 'Save').click
  30.times { break if @browser.status == "Done"; sleep 1 }
  @browser.link(:id => /home/).click
end

def fill_payment_methods(data)
  @browser.link(:text => /Payment methods/).click

  payment_methods = { "13" => "cash", "2" => "check", "14" => "mastercard", "16" => "visa", "4" => "discover", "8" => "diners", "12" => "amex", "15" => "paypal" }

  payment_methods.each do |key, method|
    @browser.div(:class => /block-content/).ul.lis.each do |list_item|
      list_item.input.click if list_item.input.attribute_value("checked") == "true"
    end
  end

  payment_methods.each do |key, method|
    @browser.div(:class => /block-content/).ul.li(:index => key.to_i).input.click if data[method]
  end
  @browser.button(:value => 'Save').click
  30.times { break if @browser.status == "Done"; sleep 1 }
  @browser.link(:id => /home/).click
end

def sign_in(data)
  @browser.goto "http://admin.cylex-usa.com/firma_signin.aspx"
  @browser.text_field(:id => /firma_id/).set data["email"]
  @browser.text_field(:id => /companypass1/).set data["password"]
  @browser.button(:id => /login/).click
end