sign_in data

@browser.text_field(:name => 'co').set "#{data['phone_area']}#{data['phone_prefix']}-#{data['phone_suffix']}"
@browser.checkbox(:id => 'coTelephone').set
@browser.link(:id => 'SearchMag').click

@browser.link(:text => data['business']).click

@browser.link(:id => 'bEditInfoButton').click
@browser.text_field(:id => 'stitle').set data['business']
@browser.text_field(:id => 'sstreet').set data['addressComb']
@browser.text_field(:id => 'szip').set data['zip']
@browser.text_field(:id => 'sphone').set data['phone']
@browser.text_field(:id => 'sfax').set data['fax']
@browser.text_field(:id => 'semail').set data['email']
@browser.text_field(:id => 'surl').set data['website']

@browser.text_field(:id => 'sTwitter').set data['twitter']
@browser.text_field(:id => 'sFacebook').set data['facebook']
@browser.text_field(:id => 'sLinkedIn').set data['linkedin']

@browser.link(:text => 'Change').click
@browser.text_field(:id => 'sCatKey').set data['category1']
@browser.button(:id => 'CatButton').click
sleep 2
@browser.link(:text => "#{data['category1']}").click
sleep 1
@browser.button(:id => 'CoButton').click
Watir::Wait.until { @browser.text.include? "Update successful!" }

@browser.link(:id => 'bEditDescriptionButton').click
@browser.text_field(:id => 'sdescription').set data['description']
@browser.button(:id => 'EditCoDescriptionButton').click
Watir::Wait.until { @browser.text.include? "Update successful!" }

if File.exist? data['logo']
  if @browser.text.include? "Upload or get your Company Logo to feature on the Home Page"
    @browser.span(:id => 'LogoText').click
  else
    @browser.span(:id => 'LogoImage').image.click
  end
  @browser.file_field(:id => 'filUpload').set data['logo']
  sleep 5
end
Watir::Wait.until { @browser.span(:id => 'LogoImage').image.exist? }

true