    seed = rand( 1000 ).to_s()
    data = {}
    data[ 'email' ]  =  business.bings.first.email #'express' + seed + '@null.com' # l29572@rtrtr.com #
    data[ 'password' ]  = business.bings.first.password
    data[ 'firstname' ] = business.contact_first_name
    data[ 'lastname' ] = business.contact_last_name
    data[ 'url' ]  = business.company_website
    data[ 'title' ]  = 'Owner'
    data[ 'phone' ] = business.local_phone
    data[ 'business_name' ] = business.business_name

    data[ 'state' ] = business.state_name
data
