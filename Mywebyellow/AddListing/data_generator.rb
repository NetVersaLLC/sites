data = {}
data[ 'pe_name' ]			= business.contact_first_name
data[ 'pe_phone' ]		= business.mobile_phone
data[ 'bu_email' ]		= business.bings.first.email
data[ 'bt_call' ]		= "5pm" #TODO
data[ 'comment' ]		= ""#TODO
data[ 'bu_name' ]			= business.business_name
data[ 'address' ]		= business.address
data[ 'city' ]			= business.city
data[ 'state' ]			= business.state_name
data[ 'zip' ]			= business.zip
data[ 'bu_phone' ] = business.local_phone
data[ 'toll_phone' ]	= business.toll_free_phone
data[ 'fax' ]		= business.fax_number
data[ 'c_email' ]		= business.bings.first.email
data[ 'description' ]			= business.business_description
data[ 'bp_represent' ]		= ""#TODO
data[ 'tag' ]		= ""#TODO/business.tags
data[ 'item1' ]		= ""#TODO/business.keyword1
data[ 'item2' ]	= ""#TODO/business.keyword2
data[ 'item3' ] = ""#TODO/business.keyword3
data[ 'item4' ] = ""#TODO/business.keyword4
data[ 'item5' ] = ""#TODO/business.keyword5
data[ 'item6' ] = ""#TODO/business.keyword6
data[ 'h_line1' ] = Getfav.consolidate_hours(business)
data[ 'h_line2' ] = ""#null
data[ 'h_line3' ] = ""#null
data[ 'h_line4' ] = ""#null
data['logo_path'] = business.logo_file_name
data[ 'payments' ] = Mywebyellow.payment_methods(business)
data[ 'url' ] = business.company_website
data[ 'menu' ] = ""#TODO
data[ 'e_cs' ] = ""#TODO
data[ 'coupon' ] = ""#TODO
data[ 'yt_emblink' ] = ""#TODO
data[ 'facebook' ] = ""#business.facebooks.first.page
data[ 'linkedin' ] = ""#business.linkedin.first.page
data[ 'twitter' ] = ""#business.twitters.first.username
data