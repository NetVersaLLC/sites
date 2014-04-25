@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def add_business(data)
  @browser.goto("http://reviews.bizzspot.com/sign-up/")
  sleep 3 
  30.times{ break if @browser.status == "Done"; sleep 1}
  if data['phone'].include? '-'
    phone = data['phone'].split('-')
  else
    phone = [
    data['phone'][0..2],
    data['phone'][3..5],
    data['phone'][6..9]]
  end
  frame = @browser.frame(:id => "wufooForms7x3q7")
  frame.text_field(:name => /Field15/).when_present.set data[ 'first_name' ]
  frame.text_field(:name => /Field16/).set data[ 'last_name' ]
  frame.text_field(:name => /Field6/).set phone[0]
  frame.text_field(:name => /Field6-1/).set phone[1]
  frame.text_field(:name => /Field6-2/).set phone[2]
  frame.text_field(:name => /Field143/).set data[ 'email' ]
  frame.text_field(:name => /Field20/).set data[ 'business' ]
  frame.text_field(:name => /Field27/).set phone[0]
  frame.text_field(:name => /Field27-1/).set phone[1]
  frame.text_field(:name => /Field27-2/).set phone[2]
  frame.text_field(:name => /Field33/).set data[ 'address' ]
  frame.text_field(:name => /Field35/).set data[ 'city' ]
  frame.select_list(:name => /Field38/).select data[ 'state' ]
  frame.text_field(:name => /Field39/).set data[ 'zip' ]
  frame.text_field(:name => /Field31/).set data[ 'category' ]
  frame.checkbox(:name => /Field42/).set
  frame.button(:name => /saveForm/).click
  sleep 3
  30.times{ break if @browser.status == "Done"; sleep 1}
  
  if Watir::Wait::until { @browser.text.include? "Questions? Chat live" }
    puts "SingUp successful"
    self.save_account("Bizzspot", {:username => data[ 'username' ], :password => data[ 'password' ], :email => data[ 'email' ]})    
    return true
  else
    throw "Miscellaneous problems."
  end    
end
    
#~ #Main Steps
add_business(data)
if @chained
  self.start("Bizzspot/Verify")
end
true