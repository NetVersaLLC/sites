data = {}
data[ 'firstname' ]		= business.contact_first_name
data[ 'lastname' ]		= business.contact_last_name
data[ 'email' ]			= business.bings.first.email
data[ 'add' ]			= "Add"
data[ 'phone' ]			= business.local_phone
data[ 'website' ]		= business.company_website
data[ 'message' ]		= "Name: " + business.business_name + "\n" + "Address: " + business.address + ' ' + business.address2 + "\n" +	"Phone: " + business.local_phone + "\n" +"Zip, State: " + business.state + ", " + business.zip + "\n" +	"URL: " + business.company_website + "\n" + "Description: " + business.business_description
data

