def are_hours_set(business)
@hoursset = false

  if business.monday_enabled
    @hoursset =  true
  elsif business.tuesday_enabled
    @hoursset =  true
  elsif business.wednesday_enabled
    @hoursset =  true
  elsif business.thursday_enabled
    @hoursset =  true
  elsif business.friday_enabled
    @hoursset =  true
  elsif business.saturday_enabled
    @hoursset =  true
  elsif business.sunday_enabled 
    @hoursset =  true
  end

@hoursset
end

mail_data = Superpage.check_email(business)
data = {
  :link 		=> mail_data[ 'temp_pass' ],
  :temp_password 	=> mail_data[ 'link' ],
  :email		=> business.bings.first.email,
  :password		=> business.bings.first.password,
  :hour24 		=> business.open_24_hours,
  :hoursset		=> are_hours_set(business),
  :description		=> business.business_description,
  :yearest		=> business.year_founded,
  :proassoc		=> business.professional_associations,
  :specials		=> business.keywords
}

