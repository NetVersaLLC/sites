data = {}
data[ 'password' ] = business.expressupdateusas.first.password
data[ 'business_email' ] = business.expressupdateusas.first.email
   data[ 'business_name' ] = business.business_name
    data[ 'business_state' ] = business.state_name
    data[ 'business_suite' ] = business.address2
    data[ 'business_city' ] = business.city
    data[ 'business_zip' ] = business.zip
    data[ 'business_address' ] =  business.address + ' '+business.address2#seed + ' main street'
    data[ 'business_phone' ] = business.local_phone
    data[ 'business_fax' ] = business.fax_number
    data[ 'business_tollfree' ] = business.toll_free_phone

    data[ 'business_url' ] = business.company_website.gsub( "www.", "").gsub("http://","")
    data[ 'business_ecommerce' ] = true #TODO
    data[ 'business_category' ] = business.category1 
    data[ 'business_products' ] = business.category1 + ', ' + business.category2 + ', ' + business.category3
    data[ 'business_services' ] = business.category4 + ', ' + business.category5
    data[ 'business_keywords' ] = business.category1 + ', ' + business.category2 + ', ' + business.category3 + ', ' + business.category4 + ', ' + business.category5
    data[ 'business_employeesize' ] = '12'

    data[ 'business_logourl' ] = data[ 'business_url' ] + '/logo.gif'
    data[ 'business_alternateurl' ] = data[ 'business_url' ]
    data[ 'business_couponurl' ] = data[ 'business_url' ] + '/coupons'

    data[ 'business_mondayopen' ] = business.monday_open
    data[ 'business_mondayclose' ] = business.monday_close
    data[ 'business_saturdayopen' ] = business.saturday_open
    data[ 'business_saturdayclose' ] = business.saturday_close
    data[ 'business_sundayopen' ] = business.sunday_open
    data[ 'business_sundayclose' ] = business.sunday_close
    
    data[ 'payment_types' ] = Expressupdateusa.payment_methods(business)

    data[ 'personal_email' ]  = business.bings.first.email #'express' + seed + '@null.com' # l29572@rtrtr.com
    data[ 'personal_password' ]  = business.bings.first.password
    data[ 'personal_firstname' ] = business.contact_first_name
    data[ 'personal_lastname' ] = business.contact_last_name
    data[ 'personal_url' ]  = business.company_website
    data[ 'personal_title' ]  = 'Owner'
    data[ 'personal_phone' ] = business.local_phone

data