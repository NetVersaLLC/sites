@browser.goto( "http://www.findstorenearu.com/index.html#store" )

@browser.text_field( :id => 'fina').set data[ 'firstname' ]
@browser.text_field( :id => 'lana').set data[ 'lastname' ]
@browser.text_field( :id => 'comp').set data[ 'business' ]
@browser.text_field( :id => 'emai').set data[ 'email' ]
@browser.text_field( :id => 'webs').set data[ 'website' ]
@browser.text_field( :id => 'prod').set data[ 'keywords' ]
@browser.text_field( :id => 'addr').set data[ 'address' ]
@browser.text_field( :id => 'cits').set data[ 'city' ]
@browser.text_field( :id => 'zips').set data[ 'zip' ]
@browser.text_field( :id => 'phon').set data[ 'phone' ]
@browser.text_field( :id => 'mobi').set data[ 'cellphone' ]
@browser.text_field( :id => 'faxs').set data[ 'fax' ]

@browser.select_list( :name => 'salut').select data[ 'prefix' ]
@browser.select_list( :name => 'state', :index => 1).select data[ 'statename' ]

@browser.file_field( :id => 'pict').set data[ 'logopath' ]

@browser.button( :value => /ADD LISTING/i).click

if @chained
  self.start("Findstorenearu/Verify")
end

true
