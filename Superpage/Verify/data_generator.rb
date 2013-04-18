mail_data = Superpage.check_email(business)
data = {
  :link 		=> mail_data[ 'temp_pass' ]
  :temp_password 	=> mail_data[ 'link' ]
  :email		=> business.bings.first.email
  :password		=> business.bings.first.password
  :hour24 		=> business.open_24_hours
  :hoursset		=> are_hours_set(business)
  :description		=> business.business_description
  :yearest		=> business.year_founded
  :proassoc		=> business.professional_associations
  :specials		=> business.keyword1 +', '+ business.keyword2 +', '+ business.keyword3 +', '+ business.keyword4 +', '+ business.keyword5
}

