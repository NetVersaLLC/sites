 # Main Script start from here
# Launch url
@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def login(data)
  url = 'http://citysquares.com/users/sign_in'
  @browser.goto url
  # 30.times{break if @browser.status == "Done"; sleep 1}
  if !data['email'].empty? and !data['password'].empty?
    @browser.text_field(:name=>'user[email]').set data['email']
    @browser.text_field(:name=>'user[password]').set data['password']
    @browser.button(:name=>'commit').click
  else
    raise StandardError.new("You must provide both a username AND password for login!")
  end 

end

def matching_result_and_claim_business(data)
    url = 'http://my.citysquares.com/search'
  @browser.goto url
  # 30.times{ break if @browser.status == "Done"; sleep 1}
  @browser.h1(:text => /Add Your Business/).wait_until_present
  @browser.text_field(:xpath=>'/html/body/div[2]/div/div[2]/div/div[2]/div[2]/div/div/div[2]/div[2]/form/div[2]/input').set data['business'] 
  @browser.text_field(:xpath=>'/html/body/div[2]/div/div[2]/div/div[2]/div[2]/div/div/div[2]/div[2]/form/div[3]/input').set data['location'] 
  sleep 20
  @browser.button(:text=>'Find my business',:class => 'btn btn-warning pull-right').click
    businessFound = false
    business_exist = @browser.link(:text=>data['business'])
    if business_exist.exist?
      business_exist.click
      sleep 10
      area_code = data['phone'][0..2]
      phone1 = data['phone'][3..5]
      phone2 = data['phone'][6..9]
      number = "(#{area_code}) #{phone1}-#{phone2}"
      puts number
      # 122 East 42nd Street , Murray, New York, 10016
      address = data['address'] +' , '+ data['location']
      puts address
      if (@browser.text.include? number) && (@browser.text.include? data['business']) && (@browser.text.include? address)
        puts "Business in list claimed."
        businessFound = true 
      else
        raise 'Something error in claiming the business.'
      end  
  end     
        return businessFound
end 

login(data)    
# 30.times{ break if @browser.status == "Done"; sleep 1}
if matching_result_and_claim_business(data)
  puts "Claiming existing business listing"
  self.save_account("Citisquare",{:status => "Listing claimed, verification status pending."})
  true
else 
  puts "Business is not listed!"
  false
end
