require "c:\\dev\\sites\\crunchbase\\shared\.rb"
require 'rubygems'
require 'watir'

@browser = browser = Watir::Browser.new
#@browser.goto('http://www.crunchbase.com/account/signup')
goto_signup_page

@browser.text_field(:id => 'user_name').set "data['name']"
@browser.text_field(:id => 'user_username').set "data['username']"
@browser.text_field(:id => 'user_password').set "data['password']"
@browser.text_field(:id => 'user_password_confirmation').set "data['password']"
@browser.text_field(:id => 'user_email_address').set "data['email']"

solve_captcha
enter_captcha
@browser.button(:name => 'commit').click
#browser.link(:href => 'http://www.crunchbase.com/account/confirmation').click