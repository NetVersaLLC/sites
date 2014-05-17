data = {
  payload_framework: PayloadFramework._to_s,
  first_name: business.contact_first_name,
  last_name: business.contact_last_name,
  email: business.bings.first.email,
  password: PayloadHelper.make_password,
  twitter_username: business.twitters.first.username,
  twitter_password: business.twitters.first.password
}