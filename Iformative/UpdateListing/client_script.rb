@browser = Watir::Browser.new
at_exit do 
  @browser.close unless @browser.nil?
end

def sign_up data
  return true unless data["username"].empty? || data["password"].empty? || data["email"].empty? 

  @browser.goto 'http://www.iformative.com/review/request/'
  sleep(30)

  @browser.link(:text,/MY ACCOUNT/).click
  sleep(30)

  @browser.link(:text,/Register/).click
  sleep(30)

  form = @browser.div(:id,'register')
  form.text_field(:name => 'nick').set data['username'] 
  form.text_field(:name => 'email').set data['new_email'] 
  form.text_field(:name => 'password').set data['new_password'] 

  @browser.button(:class,"btn-register").click
  sleep(30)
  
  if @browser.text.include? "Logout"
    self.save_account("Iformative", {
      "status"    => "Account successfully created.",
      "username"  => data["username"],
      "email"     => data["new_email"],
      "password"  => data["new_password"]
    })
  elsif @browser.div(:text => /already exists/).exist? 
    true
  else 
    raise 'Unexpected response trying to create account'
  end 
  true
end

def create_listing(data) 
  return false unless login(data)

  form = @browser.table(:class,"frame-c")
  form.text_field(:name => "product").set  data["business_name"]
  form.text_field(:name => "business").set data["business_name"]
  form.text_field(:name => "zip").set      data["zip"]
  form.text_field(:name => "address").set  data["address"]
  form.text_field(:name => "phone").set    data["phone"]
  form.text_field(:name => "web").set      data["website"]
  form.text_field(:name => "city").set     [data["city"],data["state"]].join(", ")
  form.select_list(:name => "category").select data["category"]

  @browser.button(:class,'btn-submit').click
  sleep(60)
  @browser.text.include? data["business_name"]

  self.save_account("Iformative", { "status" => "Listing successfully created.", "listing_url" => @browser.url })
  true
end

def verify_listing(data) 

  click_email =   "var fave = /Welcome to iFormative/; 
    var spans; 
    spans = document.getElementsByClassName('Sb');
    for (var i=0;i<spans.length;i++) { 
      var s; 
      s = spans[i];
      if(fave.exec(s.textContent)){ 
        s.click(); 
        return true; 
      }
    }
    return false;"

  get_verify_link =   "var go_here = /go here/; 
    var spans; 
    spans = document.getElementsByTagName('a');
    for (var i=0;i<spans.length;i++) { 
      var s; 
      s = spans[i];
      if(go_here.exec(s.textContent)){ 
        return s.href; 
      }
    }
    return;"

  @browser.goto("https://mail.live.com/") 
  sleep(30)
  @browser.text_field(:name => "login").set data['email']
  @browser.text_field(:name => 'passwd').set data['bing_password']
  @browser.form(:name => "f1").button.click
  sleep(30)

  if @browser.link(:text => 'continue to your inbox').exist? 
    @browser.link(:text => 'continue to your inbox').click
    sleep(30)
  end 

  if @browser.execute_script( click_email )
    sleep(30)
    @browser.h1(:text => /Folders/).wait_until_present

    href = @browser.div(:id => "mpf0_MsgContainer").text.match(/(http:\/\/www.iformative.com\/confirm\/email\/\S*\/)/)[1]
    @browser.goto href

    sleep(30)
    @browser.div(:text => /succesfully confirmed/).wait_until_present
    true
  else 
    false
  end 
end 

def update_listing(data) 
  true 
end 


def login data
  @browser.goto 'http://www.iformative.com/review/request/'
  sleep(30)
  @browser.link(:text,"MY ACCOUNT").click
  sleep(30)

  form = @browser.div(:id,"login")
  form.text_field(:name => "email").set data["email"] 
  form.text_field(:name => "pass").set data["password"] 

  @browser.div(:id,"login").button.when_present.click

  sleep(60)

  @browser.link(:text => /Logout/).exist?
end

@heap = JSON.parse( data['heap'] ) 

unless @heap['signed_up'] 
  @heap['signed_up'] = sign_up(data)        
  self.save_account("Iformative", {"heap" => @heap.to_json})
end 

if @heap['signed_up'] && !@heap['listing_created']
  @heap['listing_created'] = create_listing(data) 
  self.save_account("Iformative", {"heap" => @heap.to_json})
end 

if @heap['listing_created'] && !@heap['listing_verified']
  @heap['listing_verified'] = verify_listing(data) 
  self.save_account("Iformative", {"heap" => @heap.to_json})
end 

if @heap['listing_verified']
  @heap['listing_updated'] = update_listing(data) 
  self.save_account("Iformative", {"heap" => @heap.to_json})
end 

unless @heap['signed_up'] && @heap['listing_created'] && @heap['listing_verified'] && @heap['listing_updated']
  self.start("Getfave/UpdateListing", 1440)
end 
self.success

