# Developer Notes
# nil

# Browser code
@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close
  end
}

# Methods
def sign_in( data )
  @browser.goto( 'http://www.ibegin.com/account/login/' )
  @browser.text_field( :name, 'name' ).set data['email']
  @browser.text_field( :name, 'pw' ).set data['password']

  @browser.button( :value, /Login/i).click

  Watir::Wait.until { @browser.link(:text => 'Logout').exists? }
end

def create_listing(data) 
  @browser.goto('http://www.ibegin.com/business-center/submit/')
  @browser.text_field( :name, 'name').when_present.set data['business_name']

  @browser.select_list( :id, 'country').select data['country']

  Watir::Wait.until{ @browser.select(:id => 'region').options.count >= 50 } 
  @browser.select_list( :id, 'region').select data['state_name']

  Watir::Wait.until{ @browser.select(:id => 'city').options.count >= 5 } 
  @browser.select_list( :id, 'city').select data['city']

  @browser.text_field( :name, 'address').set data['address']
  @browser.text_field( :name, 'zip').set data['zip']
  @browser.text_field( :name, 'phone').set data['phone']
  @browser.text_field( :name, 'fax').set data['fax']
  @browser.text_field( :name, 'url').set data['url']
  @browser.text_field( :name, 'desc').set data['desc']
  @browser.text_field( :name, 'brands').set data['brands']
  @browser.text_field( :name, 'services').set data['services']

  category = data['category']
  puts category
  @browser.execute_script( 'document.getElementsByName("category1")[0].value="' + category +'";') 
  puts "category set" 
  
  data[ 'payment_methods' ].each{ | method |
      @browser.checkbox( :id => /#{method}/ ).clear
    }
  sleep(1)

  data[ 'payment_methods' ].each{ | method |
      @browser.checkbox( :id => /#{method}/ ).set
    }
  @browser.button( :value => /Submit Business/).click
  Watir::Wait.until { @browser.text.include? "Congratulations" }
end 

sign_in(data)
create_listing(data)

if @chained
  self.start("Ibegin/Notify")
end

self.save_account("Ibegin", { :status => "Listing created successfully. Phone verification needed." })
self.success
