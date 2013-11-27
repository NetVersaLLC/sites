def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\allthelocal_captcha.png"
  @browser.img(:id, "phoca-captcha").save  image
  CAPTCHA.solve image, :manual
end

def enter_captcha
	capSolved = false
	count = 1
	until capSolved or count > 5 do
		captcha_code = solve_captcha	
		@browser.text_field(:id, 'captcha').when_present.set captcha_code.upcase
		@browser.button(:value => 'Send').when_present.click	
		sleep(4)
		if not @browser.text.include? "Image Verification is incorrect."
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

@browser = Watir::Browser.start  "http://allthelocal.com/add_business.php"
@browser.text_field(:name, "visitor").set(data['contact_name'])
@browser.text_field(:name, "visitormail").set(data['email'])
@browser.text_field(:name, "phone").set(data['local_phone'])
@browser.text_field(:name, "business").set(data['business_name'])
@browser.text_field(:name, "address").set(data['address'])
@browser.text_field(:name, "city").set(data['city'])
@browser.text_field(:name, "state").set(data['state'])
@browser.text_field(:name, "zip").set(data['zip'])
@browser.text_field(:name, "keyword").set(data['keywords'])
@browser.text_field(:name, "url").set(data['company_website'])
@browser.text_field(:name, "notes").set(data['business_description'])

enter_captcha()

puts "Listing Submission Done!"

true
