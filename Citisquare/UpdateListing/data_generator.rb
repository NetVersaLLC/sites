data = {}
catty = Citisquare.where(:business_id => business.id).first
data['email'] = business.bings.first.email
data['password'] = business.citisquares.first.password
# data['phone_area'] = business.local_phone.split("-")[0]
# data['phone_prefix'] = business.local_phone.split("-")[1]
# data['phone_suffix'] = business.local_phone.split("-")[2]
data['phone'] = business.local_phone
data['business'] = business.business_name
data['state'] = business.state_name
data['zip'] = business.zip
data['description'] = business.business_description
data['first_name'] = business.contact_first_name
data['last_name'] = business.contact_last_name

data['address'] = business.address + ' ' + business.address2
address = business.address
data['street_number'] = address.slice!(/\d+ /)
data['predirection'] = address.slice!(/([EWNS](\w){0,4}) /)

street_types_regex = /Alley|Ally|Approach|App|Arcade|Arc|Avenue|Ave|Boulevard|Blvd|Brow|Bypass|Bypa|Causeway|Cway|Circuit|Cct|Circus|Circ|Close|Cl|Copse|Cpse|Corner|Cnr|Cove|Court|Ct|Crescent|Cres|Drive|Dr|End|Esplanande|Esp|Flat|Freeway|Fway|Frontage|Frnt|Gardens|Gdns|Glade|Gld|Glen|Green|Grn|Grove|Gr|Heights|Hts|Highway|Hwy|Lane|Link|Loop|Mall|Mews|Packet|Pckt|Parade|Pde|Park|Parkway|Pkwy|Place|Pl|Promenade|Prom|Reserve|Res|Ridge|Rdge|Rise|Road|Rd|Row|Square|Sq|Street|St|Strip|Strp|Tarn|Terrace|Tce|Thoroughfare|Tfre|Track|Trac|Trunkway|Tway|View|Vista|Vsta|Walk|Way|Walkway|Wway|Yard/
data['street_type'] = address.slice!(street_types_regex)
data['postdirection'] = address.slice!(/([EWNS](\w){0,4})/)
data['street'] = address

data['apt_type'] = business.address2.split(" ").first
data['apt_number'] = business.address2[/\d+/]
data['box_number'] = ''

data['city'] = business.city
# data['category'] = catty.citisquare_category.parent.name.gsub("\n", "")
# data['sub_category'] = catty.citisquare_category.name.gsub("\n", "")
data['specials'] = business.category1 + ' ' + business.category2 + ' ' + business.category3 + ' ' + business.category4 + ' ' + business.category5
data
