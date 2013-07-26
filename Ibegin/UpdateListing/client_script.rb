sign_in(data)

@browser.goto("http://www.ibegin.com/business-center/")

Watir::Wait.until {@browser.text.include? "Business Center"}
	

@browser.link( :text => 'Edit Listing').click

Watir::Wait.until { @browser.text.include? "Business Information" }

@browser.text_field( :name, 'name').set data['business_name']
@browser.select_list( :id, 'country').select data['country']
sleep(1)
@browser.select_list( :id, 'region').select data['state_name']
sleep(1)
@browser.select_list( :id, 'city').select data['city']
@browser.text_field( :name, 'address').set data['address']
@browser.text_field( :name, 'zip').set data['zip']
@browser.text_field( :name, 'phone').set data['phone']
@browser.text_field( :name, 'fax').set data['fax']



#Categories
#Category selection involves a popup window that must be attached to than the category searched for, then selected.
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



sleep 5

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
sleep(1)
if @browser.div( :class => 'fButtonInputRow').exists? then
@browser.div( :class => 'fButtonInputRow').input( :value => /Update My Business/).click
end

Watir::Wait.until { @browser.text.include? "Congratulations." }
true