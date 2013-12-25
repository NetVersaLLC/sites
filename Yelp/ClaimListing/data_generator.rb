data = {}
catty = Yelp.where(:business_id => business.id).first
catty = YelpCategory.find(catty.category_id)
data[ 'name' ]          = business.business_name
data[ 'first_name']     = business.contact_first_name
data[ 'last_name' ]     = business.contact_last_name
data[ 'password' ]      = Yahoo.make_password   
data[ 'city' ]          = business.city
data[ 'state' ]         = business.state
data[ 'address' ]       = business.address
data[ 'address2' ]      = business.address2
data[ 'zip' ]           = business.zip
data[ 'phone' ]         = business.local_phone
data[ 'website' ]       = business.company_website
data[ 'email' ]         = business.bings.first.email

data['category']        = catty.name

begin 
data['parent']          = catty.parent.name
rescue
    data['parent']          = ""
end

begin
    data['rootcat']         = catty.parent.parent.name
rescue
    data['rootcat']         = ""
end

if data['rootcat'] == 'root'
  data['rootcat'] = ""
end
if data['parent'] == 'root'
  data['parent'] = ""
end
if data['category'] == 'root'
  data['category'] = ""
end

data
