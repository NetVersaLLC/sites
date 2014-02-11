data = {
  "username" => business.bings.first.email.split("@").first,
  "email" => business.bings.first.email,
  "password" => Yahoo.make_password,
}