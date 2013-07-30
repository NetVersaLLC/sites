data = {}
seedString 					= rand( 1000 ).to_s()
data[ 'userName' ] 			= (business.contact_first_name + business.contact_last_name + seedString).to_s.gsub(/\s+/, '')
data[ 'email' ]				= business.bings.first.email
data[ 'pass' ]				= Kudzu.make_password
data[ 'securityQuestion' ]	= 'City of Birth?'
data[ 'answer' ] 			= Kudzu.make_secret_answer
data