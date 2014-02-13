@browser = Watir::Browser.new :firefox
at_exit do
	unless @browser.nil?
		@browser.close
	end
end

def sign_in(data)
	puts data['email']
	puts data['password'] 

  @browser.goto "http://www.fyple.com/login/"
  @browser.text_field(:id => "CPL_LogIn1_TUserName").set data['email']
  @browser.text_field(:id => "CPL_LogIn1_TPassword").set data['password']
  @browser.form(:id => "form1").button.click 
  Watir::Wait.until do 
    if @browser.text.include?("Server Error")
      @browser.back
      @browser.text_field(:id => "CPL_LogIn1_TUserName").set data['email']
      @browser.text_field(:id => "CPL_LogIn1_TPassword").set data['password']
      @browser.form(:id => "form1").button.click 
    end
    @browser.link(:id => /MyProfile1_HGoTo/).exist?
  end 
  
end 

def remove_images 
  if @browser.link(:id => /editPhotos1_DL_LDell/).exist?
    @browser.link(:id => /editPhotos1_DL_LDell/).click
    @browser.alert.ok

    remove_images
  end 
end 


def create_listing(data)
  @browser.link(:id => /MyProfile1_HGoTo/).click
  #check for existing data
  if @browser.link(:id => /_LCompany_/).exist?
    @browser.link(:id => /_LCompany_/).click
  else
    @browser.goto "http://www.fyple.com/my-account/add-data/"
    @browser.text_field(:id => /_TName_text/ ).set data['business']
    @browser.text_field(:id => /_RWhere_/).set data['city_state']
    @browser.text_field(:id => /TPhoneNumber_text/).set data['lphone']
    @browser.button(:text => "Continue >").click 
  end 

  @browser.text_field(:id => /_TName_text/ ).set data['business']
  @browser.text_field(:id => /_TAddress1_/).set  data['address1']
  @browser.text_field(:id => /_TAddress2_/).set  data['address2']
  @browser.text_field(:id => /_RWhere_/).set     data['city_state']
  @browser.text_field(:id => /_TZip_/).set       data['zip']
  @browser.text_field(:name => /PhoneAlternate/).set data['aphone']
  @browser.text_field(:name => /PhoneMobile/).set data['mphone']
  @browser.text_field(:name => /WebSite/).set    data['url']
  @browser.button(:text => "Save").click 


  @browser.link(:href => /edit-companydescription/).click
  @browser.text_field(:name => /Description1/).set data['desc']
  @browser.button(:text => "Save").click 
  @browser.back

  @browser.link(:href => /edit-acceptedpayments/).click
  @browser.table(:id => /AcceptedPayments/).checkboxes.each{|c| c.clear} 
  data['payments'].each do |p| 
    id = @browser.span(:text => p).id.gsub(/LName/, "CSelect")
    @browser.checkbox(:id => id).set 
  end 
  @browser.button(:text => "Save").click 

  @browser.link(:href => /edit-photos/).click
  remove_images
  self.images.each do |f| 
    puts "uploading #{f}"
    @browser.file_field(:id => "CPL_ctl_ctl_editPhotos1_FileUpload1").value= f
    @browser.button(:id => "CPL_ctl_ctl_editPhotos1_Button1").click
  end 

  @browser.link(:text => "View listing page").click
  @browser.windows[1].url
end 

sign_in(data)
listing_url = create_listing(data)

self.save_account("Fyple", {:listing_url => listing_url, :status => "Listing created."})
self.success


