@browser = Watir::Browser.new :firefox
at_exit {
  unless @browser.nil?
    @browser.close
  end
}
def sign_in( data )
  @browser.goto( 'https://www.merchantcircle.com/auth/login' )
  @browser.text_field( :name => 'email').set data['email']
  @browser.text_field( :name => 'password').set data['password']
  sleep 10
  @browser.button( :class => 'redBtn').click
end

sign_in(data)

@browser.goto("http://www.merchantcircle.com/merchant/edit")

@browser.text_field(:id, "name").set data['name']
@browser.text_field(:id, "address").set data['address']
@browser.text_field(:id, "address2").set data['address2']
@browser.text_field(:id,"city").set data["city"]
@browser.select_list(:id,"state").select data['state']

@browser.text_field(:id, "zip").set data['zip']
@browser.text_field(:id, "telephone").set data['phone']

@browser.textarea(:id,"description").set data['description']
@browser.select_list(:name,"NewHours-0.openingStart").select data[ 'sunOpen' ]
@browser.select_list(:name,"NewHours-0.closingEnd").select data[ 'sunClose' ]

['2','3','4','5','6','7'].each do |i|
  
  # puts value
  url = '/html/body/div[4]/div[3]/form/fieldset/table/tbody/tr[13]/td/table/tbody/'+'tr['+i+']'+'/td[5]/a'
    puts url
  @browser.link(:xpath=>url).click
end
sleep 10


data[ 'payment_methods' ].each{ | method |
    @browser.checkbox( :name => method ).set
    break
  }
@browser.text_field(:id, "url").set data['website']
sleep 10
@browser.text_field(:id, "tags").set data['keywords'] 

@browser.button(:name => 'updateListing').click
sleep(3)

@browser.goto("http://www.merchantcircle.com/merchant/category")

data['thecategories'].each_pair do |name,cat|
  @browser.select_list(:id => name).option(:text => cat).click
  puts cat
end

@browser.button(:id=>'add').click

# @browser.goto("http://www.merchantcircle.com/merchant/category")

# sleep(2) # let all the javascript load.

# cats = data['thecategories']
# @browser.select_list(:id => 'levelone').option(:text => /#{cats['levelone']}/i).click
# sleep(3)
# @browser.select_list(:id => 'leveltwo').option(:text => /#{cats['leveltwo']}/i).click
# sleep(3)
# if cats['levelthree']
# 	@browser.select_list(:id => 'levelthree').option(:text => /#{cats['levelthree']}/i).click
# end

@browser.goto("https://www.merchantcircle.com/merchant/profilePicture")
@browser.button(:class=>'buttonGreen').click
@browser.window(:index=>1).use
@browser.link(:xpath,'/html/body/div/h3/a').click
unless self.logo.nil? 
  data['logo'] = self.logo
else
  data['logo'] = self.images.first unless self.images.nil?
end
sleep 20
unless data['logo'].nil?
  
  @browser.file_field(:xpath => '/html/body/div/form/fieldset/input').set data['logo']
  @browser.button(:xpath=>'/html/body/div/form/fieldset/input[2]').click
  Watir::Wait.until { @browser.text.include? "Picture upload successful." }
  @browser.button(:xpath=>'/html/body/div/div[3]/input[2]').click

end
puts "Your list successfully updated."


true
