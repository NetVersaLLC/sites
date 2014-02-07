@browser = Watir::Browser.new :firefox
at_exit {
	unless @browser.nil?
	  @browser.close
	end
}


def sign_in( data )

retries = 5

begin
@browser.goto( 'http://www.ibegin.com/account/login/' )
@browser.text_field( :name, 'name' ).set data['email']
@browser.text_field( :name, 'pw' ).set data['password']

@browser.button( :value, /Login/i).click

sleep 2
Watir::Wait.until { @browser.link(:text => 'Logout').exists? }
return true
rescue
if retries > 0
        puts "There was an error with the SignUp. Retrying in 5 seconds."
        retries -= 1
        sleep 5
        retry
    else
        puts "After 5 retries the payload could not sign in. Data available:"
        puts data
        puts "Data required:"
        puts "email,password"
        throw("Job failed during login. Verify the credintials are valid")
    end
end
end

def update_listing(data)
  @browser.goto("http://www.ibegin.com/business-center/")

  Watir::Wait.until {@browser.text.include? "Business Center"}

  @browser.link( :text => 'Edit Listing').click

  Watir::Wait.until { @browser.text.include? "Business Information" }

  @browser.text_field( :name, 'name').set data['business_name']
  @browser.select_list( :id, 'country').select data['country']
  Watir::Wait.until{ @browser.select(:id => 'region').options.count >= 50 } 
  @browser.select_list( :id, 'region').select data['state_name']
  Watir::Wait.until{ @browser.select(:id => 'city').options.count >= 10 } 

  @browser.select_list( :id, 'city').select data['city']
  @browser.text_field( :name, 'address').set data['address']
  @browser.text_field( :name, 'zip').set data['zip']
  @browser.text_field( :name, 'phone').set data['phone']
  @browser.text_field( :name, 'fax').set data['fax']

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

  @browser.text_field( :name, 'url').set data['url']
  @browser.text_field( :name, 'facebook').set data['facebook']
  @browser.text_field( :name, 'twitter_name').set data['twitter_name']
  @browser.text_field( :name, 'desc').set data['desc']
  @browser.text_field( :name, 'brands').set data['brands']
  @browser.text_field( :name, 'products').set data['products']
  @browser.text_field( :name, 'services').set data['services']

  @browser.button( :value => /Update Business/).click

  @browser.link(:text => 'instantly live on iBegin').when_present.click
  @browser.url   
end 

sign_in(data)
listing_url = update_listing(data)

self.save_account("Ibegin", { :status => "Listing updated successfully!", :listing_url => listing_url})
self.success
