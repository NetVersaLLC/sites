data = {
  payload_framework: PayloadFramework._to_s,
  username: [business.name, rand(1000)].join.gsub(/\s/,''),
  email: business.bings.first.email,
  password: PayloadHelper.make_password,
  secret_question: 'City of Birth?',
  secret_answer: Faker::Address.city
}