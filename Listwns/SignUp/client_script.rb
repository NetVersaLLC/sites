#!/usr/bin/env ruby

require 'mechanize'

agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

page = agent.get('http://www.listwns.com/home/register.aspx')
form = page.form_with("form1")
form.email = data['email']
form.pw1 = data['password']
form.pw2 = data['password']
form.checkbox_with("agree").checked = true

# binding.pry
# exit
self.save_account('Listwns', { :username => data['email'], :password => data['password']})

# page = form.click_button(form.button_with(:type => 'submit'))
# form = page.form_with("form1")
# form.title = data['business']
# form.phone = data['phone']
# form.address = data['address']
# form.bztype = data['category']
# form.city = data['city']
# form.country = data['country']
# form.zipcode = data['zip']
# form.content = data['description']
# form.tag = data['keywords']
# page = form.click_button(form.button_with(:type => 'submit'))
# true

