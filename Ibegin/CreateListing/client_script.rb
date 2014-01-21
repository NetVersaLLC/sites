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

def initial_signup(data)
  @browser.goto('http://www.ibegin.com/business-center/submit/')
  @browser.text_field( :name, 'name').when_present.set data['business_name']
  @browser.select_list( :id, 'country').select data['country']
  sleep(3)
  @browser.select_list( :id, 'region').select data['state_name']
  sleep(3)
  @browser.select_list( :id, 'city').option(:text => /#{data['city']}/i).click
  @browser.text_field( :name, 'address').set data['address']
  @browser.text_field( :name, 'zip').set data['zip']
  @browser.text_field( :name, 'phone').set data['phone']
  @browser.text_field( :name, 'fax').set data['fax']
end

def loop_cats(data)
  catarray = data['category1'].split(" ")
  wordcount = catarray.length
  count = 0
  cat_found = false

  while wordcount > count && cat_found != true
    @browser.window( :title, "Categories Selector | iBegin").when_present.use do
      query = catarray[count]
      @browser.text_field( :id, 'id_q').set query
      @browser.button( :value, 'Go').click
      sleep 5
      if @browser.link(:text => /#{query}/i).exists?
        @browser.link(:text => /#{query}/i).click
        cat_found =true
      end
      count+=1
    end
  end

end

def set_category(data)
  puts "Category: #{data['category1']}"
  category = data[ 'category1' ]
  query = data[ 'category1' ]
  wordcount = data[ 'category1' ].split(" ").size
  count = 0
  #Categories
  #Category selection involves a popup window that must be attached to than the category searched for, then selected.
  # If the category cannot be found it will split the category into single words and search word by word until it finds the category
  @browser.div( :id => 'id_category1_wrap', :index => 0 ).link( :title, 'Select' ).click

  sleep 2
  Watir::Wait.until { @browser.window( :title, "Categories Selector | iBegin").exists? }

  @browser.window( :title, "Categories Selector | iBegin").when_present.use do
    @browser.text_field( :id, 'id_q').set query
    @browser.button( :value, 'Go').click
    sleep 4
    if @browser.link(:text => "#{data['category1']}").exists?
      @browser.link(:text => "#{data['category1']}").click
    else
      loop_cats(data)
    end   
  end
end

def set_socialmedia(data)
  @browser.text_field( :name, 'url').set data['url']
  @browser.text_field( :name, 'facebook').set data['facebook']
  @browser.text_field( :name, 'twitter_name').set data['twitter_name']
  @browser.text_field( :name, 'desc').set data['desc']
  @browser.text_field( :name, 'brands').set data['brands']
  @browser.text_field( :name, 'products').set data['products']
  @browser.text_field( :name, 'services').set data['services']
end

def set_pay_methods(data)
  data[ 'payment_methods' ].each{ | method |
    @browser.checkbox( :id => /#{method}/ ).click
  }
end

# Main Controller
sign_in(data)
initial_signup(data)
set_category(data)
set_socialmedia(data)
set_pay_methods(data)
@browser.button( :value => /Submit Business/).click
Watir::Wait.until { @browser.text.include? "Congratulations" }

if @chained
  self.start("Ibegin/Notify")
end

self.save_account("Ibegin", { :status => "Listing created successfully!" })
self.success
