def add_business(data)
  @browser.goto("http://reviews.bizzspot.com/sign-up/")
  sleep 10  
  30.times{ break if @browser.status == "Done"; sleep 1}
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field15/).when_present.set data[ 'first_name' ]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field16/).set data[ 'last_name' ]
  phone = data['phone']
  a1=phone.split("-")
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field6/).set a1[0]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field6-1/).set a1[1]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field6-2/).set a1[2]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field143/).set data[ 'email' ]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field20/).set data[ 'business' ]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field27/).set a1[0]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field27-1/).set a1[1]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field27-2/).set a1[2]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field33/).set data[ 'address' ]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field35/).set data[ 'city' ]
  @browser.frame(:id => "wufooForms7x3q7").select_list(:name => /Field38/).select data[ 'state' ]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field39/).set data[ 'zip' ]
  @browser.frame(:id => "wufooForms7x3q7").text_field(:name => /Field31/).set data[ 'category' ]
  @browser.frame(:id => "wufooForms7x3q7").checkbox(:name => /Field42/).set
  @browser.frame(:id => "wufooForms7x3q7").button(:name => /saveForm/).click
  sleep 15
  30.times{ break if @browser.status == "Done"; sleep 1}
  
  if Watir::Wait::until { @browser.text.include? "Questions? Chat live" }
    puts "SingUp successful"
    self.save_account("Bizzspot", {:username => data[ 'username' ], :password => data[ 'password' ], :email => data[ 'email' ]})    
    return true
  else
    throw "Mislleneous problems."
  end    
end
    
#~ #Main Steps
add_business(data)