data = {}
seedString 			= rand( 1000 ).to_s()

catty                       = Kudzu.where(:business_id => business.id).first
data[ 'industry' ]          = catty.kudzu_category.parent.name.gsub("\n", "")
data[ 'category' ]       = catty.kudzu_category.name.gsub("\n", "")
data[ 'userName' ] 		= (business.contact_first_name + business.contact_last_name + seedString).to_s.gsub(/\s+/, '')
data[ 'email' ]			= business.bings.first.email
data[ 'pass' ]			= Kudzu.make_password
data[ 'securityQuestion' ]	= 'City of Birth?'
data[ 'answer' ] 		= Kudzu.make_secret_answer
data[ 'prefix' ]		= business.contact_prefix
data[ 'firstName' ]		= business.contact_first_name
data[ 'lastName' ]		= business.contact_last_name
data[ 'businessName' ]		= business.business_name
data[ 'website' ]		= business.company_website
data[ 'busAddress1' ]		= business.address
data[ 'busAddress2' ]		= business.address2
data[ 'busCity' ]		= business.city
data[ 'busState' ]		= business.state
data[ 'busZip1' ]		= business.zip
data[ 'busNPA' ]		= business.local_phone.split("-")[0]
data[ 'busNXX' ]		= business.local_phone.split("-")[1]
data[ 'busPlusFour' ]		= business.local_phone.split("-")[2]
data[ 'busExtension' ]		= ''#TODO
data[ 'busFaxNPA' ]		= business.fax_number.split("-")[0]
data[ 'busFaxNXX' ]		= business.fax_number.split("-")[1]
data[ 'busFaxPlusFour' ]	= business.fax_number.split("-")[2]
data[ 'paymentTypes' ] = [ :AmericanExpress, :DebitCard, :MasterCard ]
data[ 'languagesSpoken' ] = [ :English, :Spanish ]
data[ 'yearEstablished' ] = business.year_founded.to_s
data
