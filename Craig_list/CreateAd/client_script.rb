
def select_category(category,sub_category,sub_category2,my_gender,partner_gender,cat,sub,sub2)
	my_gender = "w" if my_gender == 'Woman'
	my_gender  = 'm' if my_gender  == 'Man'
	partner_gender = "w" if partner_gender == 'Woman'
	partner_gender  = 'm' if partner_gender  == 'Man'
	
	case category
		when "community", "event", "service offered", "for sale", "housing offered", "housing wanted"
		  @browser.radio(:value,"#{cat}").set
		  @browser.radio(:value,"#{sub}").set
		when "resume / job wanted", "item wanted"
		  @browser.radio(:value,"#{cat}").set
		when "job offered"
		  @browser.checkbox(:value,"#{cat}").set
		when "gig offered "
		  @browser.radio(:value,"#{cat}").set
		  @browser.radio(:value,"#{sub}").set
		  @browser.radio(:value,"#{sub2}").set
		when "personal / romance"
		  @browser.radio(:value,"#{cat}").set
		  @browser.radio(:value,"#{sub}").set
		  @browser.radio(:id,"#{my_gender}").set
		  @browser.radio(:id,"#{partner_gender}2").set
		  @browser.button(:value => 'Continue').click
		else
		  puts "Please select a valid category"
		end
	end

def sign_out()
@sign_out = @browser.link(:text,'log out')
@sign_out.click if @sign_out.exist?
end

def sign_in(data)
	@browser.text_field(:name => 'inputEmailHandle').set data[ 'email']
	@browser.text_field(:name => 'inputPassword').set data[ 'password']
	@browser.button(:type => 'submit').click
	if @browser.p(:class, "error").exists?
		throw("Login Invalid")
	end
	@terms = @browser.button(:value => 'I ACCEPT')
	@terms.click if @terms.exist?
end

def post_ad(data)
	@browser.link(:text => 'new posting').click
	@browser.select_list(:name => 'areaabb').select data['city']
	@browser.button(:value => 'go').click
	#Select Categories

	select_category(data['category'],data['sub_category'],data['sub_category2'],convert_gender(data['my_gender']),data['partner_gender'], data['catCode'], data['subCode'], data['subCode2'])
	@browser.radio(:value,"#{data['nearest_city']}").set
	@browser.radio(:value,"#{data['location']}").set
	@browser.text_field(:class => 'req', :index => 0).set data['posting_title']
	@browser.text_field(:class => 'req', :index => 1).set data['posting_description'] 
	@browser.text_field(:class => 's').set data['age'] if @browser.text_field(:class => 's').exist?
	@browser.button(:value => 'Continue').click
	#Check for Error
	if @browser.span(:class,'err').exist?
		throw "Showing error while posting: #{@browser.span(:class,'err').text}"
	end
	# Upload Image
	@browser.file_field(:name => "file").set data['image_path'] if data['image_path'] != ""
	#~ sleep(5)
	@browser.button(:value => 'Done with Images').click
	# Check for successful posting
	if @browser.div(:class,'posting').text.include?(data['posting_title'])
		puts "Successfully posted"
	else
		throw("Posting failed")
	end
	@browser.button(:value => 'Continue').click
end

@url = 'www.craigslist.com'
begin
@browser.goto(@url)
@preferred_city = @browser.link(:text => "#{data[ 'preferred_city' ]}")
@preferred_city.click if @preferred_city.exist?
@browser.link(:text => 'my account').click


#Sign in
sign_in(data)
#Post an ad
post_ad(data)
#Publish ad form email. Todo
publish_ad(data)

rescue Exception => e
  puts("Exception Caught in Business Listing")
  puts(e)
end

