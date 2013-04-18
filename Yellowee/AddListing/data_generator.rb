data = {}
catty                       = Yellowee.where(:business_id => business.id).first
data[ 'email' ]			= business.yellowees.first.username
data[ 'password' ]		= business.yellowees.first.password#6UfOlU2YGmQ
data[ 'business' ]		= business.business_name
data[ 'query' ]			= business.city + ", " + business.state + ", United States"
data[ 'address' ]		= business.address
data[ 'address2' ]		= business.address2
data[ 'zip' ]			= business.zip
data[ 'phone' ]			= business.local_phone
data[ 'website' ]		= business.company_website

data['cat1'] = catty.yellowee_category.parent.name
data['cat2'] = catty.yellowee_category.name

#data['cat3'] = catty.yellowee_category.name

#if not catty.yellowee_category.parent == nil
#  data['cat2'] = catty.yellowee_category.parent.name
#end

#if not catty.yellowee_category.parent.parent == nil
#  data['cat1'] = catty.yellowee_category.parent.parent.name
#end

data[ 'hours' ]			= Justclicklocal.get_hours( business )
data[ 'description' ]		= business.business_description
data[ 'founded' ]		= business.year_founded
data
