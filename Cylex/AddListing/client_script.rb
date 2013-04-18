def search_result(data)

  @browser.text_field(:name => /companyname/).set data[ 'business' ]
  @browser.text_field(:name => /city/).set data[ 'city' ]
  @browser.text_field(:name => /website/).set data[ 'website' ]
  @browser.button(:value=> 'Check name').click
  @browser.wait()
end

def add_new_business(data)
  @browser.link(:text => 'Add Company').click
  @browser.text_field(:name => /companyname/).set data[ 'business' ]
  @browser.text_field(:name => /companypass1/).set data[ 'password' ]
  @browser.text_field(:name => /companypass2/).set data[ 'password' ]
  @browser.text_field(:name => /companystreet/).set data[ 'address' ]
  @browser.text_field(:name => /companycity/).set data[ 'city' ]
  sleep(4)
  @browser.link(:xpath => '//*[@id="ctl00_bodyadmin"]/ul[2]/li/a').when_present.click
  @browser.text_field(:name => /postnr/).set data[ 'zip' ]
  @browser.text_field(:name => /companymail/).set data[ 'email' ]
  @browser.text_field(:name => /companyphone/).set data[ 'phone' ]
  @browser.checkbox(:name => /cbaccept/).set

  #Enter Captcha Code
  enter_captcha(data) 
  #Check for error
  #@error_msg = @browser.span(:class => 'message error no-margin')
  #if @error_msg.exist?
  #  puts "Showing error message saying #{@error_msg.text}"
  #end

  #Step 2
  @browser.text_field(:name => /tb_keywords/).when_present.set data[ 'keywords' ]
  @browser.text_field(:name => /tb_shortdesc/).set data[ 'business_description' ]
  @browser.button(:value => 'Save').click

  
  #Check for confirmation
  @success_text ="Thank you very much for the registration of your company profile in our business directory."
  
  if @browser.span(:id => /registered_infotext/).text.include?(@success_text)
    puts "Initial Business registration is successful"
    RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[email]' => data[ 'username' ], 'account[password]' => data['password'], 'model' => 'Cylex'
    return true
  else
    throw "Initial Business registration is Unsuccessful"
  end
end

def search_company(data)
  @business_found = false
  
  if @browser.table(:id=> /companynamechecking_gv_companies/).exist?
    @table = @browser.table(:id => /companynamechecking_gv_companies/)
    @table.rows.each do |row|
      if row[1].text == data[ 'business' ]
        puts "Claiming the business"
row.link(:text => 'This is my company').click
        @business_found = true
        break
      end
    end
  end
  return @business_found
end

def claim_business(data)
  @browser.radio(:value => "#{data[ 'role' ]}").set
  @browser.text_field(:name => /companyname/).set data[ 'business' ]
  @browser.text_field(:name => /companystreet/).set data[ 'address' ]
  @browser.text_field(:name => /companycity/).set data[ 'city' ]
  @browser.text_field(:name => /postnr/).set data[ 'zip' ]
  @browser.select_list(:name => /state2/).select data[ 'state' ]
  @browser.text_field(:name => /companyphone/).set data[ 'phone' ]
  @browser.text_field(:name => /companyweb/).set data[ 'website' ]
  @browser.text_field(:name => /companymail/).set data[ 'email' ]
  @browser.text_field(:name => /tb_keywords/).set data[ 'keywords' ]
  @browser.text_field(:name => /tb_shortdesc/).set data[ 'business_description' ]
  rolewise_info_update(data)
  @browser.text_field(:name => /captchaTb/).set captcha
  @browser.button(:value => 'Save changes').click
  
  #Check for confirmation
  @success_text ="Thank you for updating the company presentation page! "
  
  if @browser.span(:id => /registered_infotext/).text.include?(@success_text)
    puts "Business has been claimed successful"
  else
    throw "Business has not been claimed successful"
  end
end

def rolewise_info_update(data)
  if data[ 'role' ] == 'owner'
    @browser.text_field(:id => /tb_complain/).set data[ 'reason_for_info_update']
    @browser.select_list(:name => /ddltitle/).select data[ 'name_title' ]
    @browser.text_field(:id => /owner_firstname/).set data[ 'first_name']
    @browser.text_field(:id => /owner_surname/).set data[ 'last_name']
    @browser.text_field(:id => /ddldept/).set data[ 'department']
    @browser.text_field(:id => /owner_email/).set data[ 'email']
  elsif data[ 'role' ] == 'visitor'
    @browser.text_field(:id => /tb_complain/).set data[ 'reason_for_info_update']
    @browser.text_field(:id => /owner_firstname/).set data[ 'first_name']
    @browser.text_field(:id => /owner_surname/).set data[ 'last_name']
  end
end
    
#~ #Main Steps
#~ # Launch browser
@url = 'http://admin.cylex-usa.com/firma_default.aspx?step=0&d=cylex-usa.com'
@browser.goto(@url)

# Search for Business

search_result(data)
if search_company(data)
  claim_business(data)
else
  add_new_business(data)
end
