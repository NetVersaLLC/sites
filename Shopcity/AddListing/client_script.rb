@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
		@browser.close
	end
}

# temp copy from shared.rb

def sign_in(data)
  @browser.goto("http://www.shopcity.com/map/mapnav_locations.cfm?")
  @browser.link(:text => /#{data['country']}/).when_present.click
  @browser.link(:text => /#{data['state']}/).when_present.click
  @browser.link(:text => /#{data['cityState']}/).when_present.click 
  @browser.link(:title => 'Login').when_present.click
  @browser.text_field(:name => 'email').when_present.set data['email']
  @browser.text_field(:name => 'pw').set data['password']
  @browser.link(:text => "Sign Me In").click
end

def fill_payment_methods(data)
  payments = data['payments']
  payments.each do |payment|
    @browser.checkbox(:id => payment).click
  end
end

def fill_logo(data)
  unless self.logo.nil? 
    @browser.file_field(:name => 'photo01').set self.logo
  else
    @browser.file_field(:name => 'photo01').set self.images.first unless self.images.empty?
  end
end

def fill_contact_info(data)
  @browser.text_field(:name => 'businessname').when_present.set data['business']
  @browser.text_field(:name => 'contact').set data['fullname']
  @browser.text_field(:name => 'address1').set data['address']
  @browser.text_field(:name => 'address2').set data['address2']
  @browser.text_field(:name => 'city').set data['city']
  @browser.text_field(:name => 'province').set data['state_name']
  @browser.text_field(:name => 'country').set data['country']
  @browser.text_field(:name => 'postal').set data['zip']
  @browser.text_field(:name => 'phone').set data['phone']
  @browser.text_field(:name => 'fax').set data['fax']
  @browser.text_field(:name => 'tollfree').set data['tollfree']
  @browser.text_field(:name => 'email').set data['email']
end

def fill_categories(data)
  @browser.text_field(:id => 'searchCategories').when_present.set data['category1']
  sleep 5
  @browser.select_list(:id => 'SelectList').option(:index => 0).click
  @browser.img(:title => 'Add to List').click
end

def fill_titles(data)
  @browser.text_field(:name => 'sitetitle').when_present.set data['business']
end

# end temp copy from shared.rb

sign_in(data)
@browser.link( :text => "Add Business").when_present.click
@browser.link( :href => /package=10000004/).when_present.click
@browser.text_field( :id => "subfolder_name").when_present.set data[ 'siteName' ]
@browser.span( :text => "GET STARTED!").click

#Fillout Contact Details
fill_contact_info(data)
@browser.checkbox( :id => 'agree').set
@browser.button(:value => /Next/).click

#Categories
count = 0
until @browser.text.include? "Set Your Hours"
  if count == 5
    throw "Categories could not be set"
  end
  fill_categories(data)
  sleep 2 # Won't save cats without a pause
  @browser.button(:xpath => '//*[@id="categories_page"]/form/div[2]/div[2]/input').click
  sleep 5
  count += 1
end

#Hours
#ToDo
sleep 5
@browser.button(:xpath => '//*[@id="hours_page"]/form/div[2]/div[2]/input').click

#Payment methods
sleep 5
fill_payment_methods(data)
@browser.button(:xpath => '//*[@id="pay_methods_page"]/form/div/div[2]/input').click

#Title & Description
fill_titles(data)
@browser.button(:xpath => '//*[@id="description_page"]/form/div/div[2]/input').click

#Logo
sleep 5
#fill_logo(data) Fix later
@browser.button(:xpath => '//*[@id="stage7Form"]/div[3]/div[2]/input').click
sleep 2
@browser.button(:value => /Finish/).when_present.click

Watir::Wait.until { @browser.text.include? "What's New" }

true