data = {}
catty = Ebusinesspage.where(:business_id => business.id).first
data['category1'] = catty.ebusinesspage_category.name.gsub("\n", "")
data['business'] = business.business_name
data['addressComb'] = business.address + "  " + business.address2
data['zip'] = business.zip
data['phone'] = business.local_phone
data['phone_area'] = business.local_phone.split("-")[0]
data['phone_prefix'] = business.local_phone.split("-")[1]
data['phone_suffix'] = business.local_phone.split("-")[2]
data['fax'] = business.fax_number
data['email'] = business.bings.first.email
data['website'] = business.company_website
data['username'] = business.ebusinesspages.first.username
data['password'] = business.ebusinesspages.first.password
data['description'] = business.business_description

data['twitter'] = business.twitters.first.nil? ? '' : business.twitters.first.twitter_page
# data['facebook'] = business.facebooks.first.nil? ? '' : business.facebooks.first.facebook_page
data['linkedin'] = ''#business.linkedins.first.nil? ? '' : business.linkedins.first.username #Currently doesn't exist
#data['logo'] = ContactJob.logo.nil? ? '' : ContactJob.logo #ContactJob outdated, self.logo referred to in client_script.rb
data
