data = {}
catty = Ebusinesspage.where(:business_id => business.id).first
data[ 'category1' ]            = catty.ebusinesspage_category.name.gsub("\n", "")
data[ 'business' ]		        = business.business_name
data[ 'addressComb' ]		      = business.address + "  " + business.address2
data[ 'zip' ]			            = business.zip
data[ 'phone' ]			          = business.local_phone
data[ 'fax' ]		            	= business.fax_number
data[ 'email' ]			          = business.bings.first.email
data[ 'website' ]	          	= business.company_website
data['username']			= business.ebusinesspages.first.username
data['password']			= business.ebusinesspages.first.password
data
