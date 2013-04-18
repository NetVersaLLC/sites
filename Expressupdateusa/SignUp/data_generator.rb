    seed = rand( 1000 ).to_s()
    data = {}
    data[ 'personal_email' ]  =  business.bings.first.email #'express' + seed + '@null.com' # l29572@rtrtr.com #
    data[ 'personal_password' ]  = business.bings.first.password
    data[ 'personal_firstname' ] = business.contact_first_name
    data[ 'personal_lastname' ] = business.contact_last_name
    data[ 'personal_url' ]  = business.company_website
    data[ 'personal_title' ]  = 'Owner'
    data[ 'personal_phone' ] = business.local_phone
    data[ 'business_name' ] = business.business_name
    data[ 'business_phone' ] = business.local_phone

    data[ 'business_state' ] = business.state_name
data
