@browser = Watir::Browser.new :firefox

at_exit {
  unless @browser.nil?
    @browser.close
  end
}

def signup(data) 
  @browser.goto "http://www.mysheriff.net/users/"

  @browser.radio(:value => data['gender']).set

  add_user_form = @browser.form(:id => 'AddUser') 

  @browser.text_field(:name => 'firstname').set     data['first_name']
  @browser.text_field(:name => 'lastname').set      data['last_name']
  @browser.text_field(:name => 'email_address').set data['email']

  @browser.select_list(:name=>'cmbmonth').select    data['birthday']['month']
  @browser.select_list(:name=>'cmbday').select      data['birthday']['day']
  @browser.select_list(:name=>'cmbyear').select     data['birthday']['year']

  # city displays a drop down that you need to select from
  @browser.text_field(:name => 'City').set          data['city']
  @browser.div(:class => 'ac_results', :text => /#{data['city']}/).wait_until_present
  @browser.div(:class => 'ac_results').li(:text => /#{data['state']}/).click

  3.times do 
    add_user_form.text_field(:id   => 'password').set      data['password']
    @browser.text_field(:name => 'verif_box').set     solve_captcha( @browser.form(:id => 'AddUser').image )
    @browser.button(:value => 'Sign Up').click

    break if @browser.h1(:text => /Nice to see you/).exist?
    break if @browser.li(:text => /email address has already been used/).exist?
  end 
  @browser.h1(:text => /Nice to see you/).exist? || @browser.li(:text => /email address has already been used/).exist?
end 

def solve_captcha(image_element)
  image_file = "#{ENV['USERPROFILE']}\\citation\\mysheriff_captcha.png"
  puts "CAPTCHA width: #{image_element.width}"
  image_element.save image_file
  sleep(3)

  return CAPTCHA.solve image_file, :manual
end

if signup(data) 
  self.save_account('Mysheriff', {:email => data['email'], :password => data['password'], :status => "Account created, posting listing..."})
  if @chained
    self.start("Mysheriff/CreateListing")
  end 
  self.success
else 
  reg_error = @browser.div('reg_error')
  if reg_error.exist? && reg_error.lis.count == 1 && reg_error.text.include?('image Correctly') 
    if @chained
      self.start("Mysheriff/SignUp", 1440) 
    end 
    self.failure "captcha failed. trying again later"
  else
    raise "Error filling out form" 
  end
end


