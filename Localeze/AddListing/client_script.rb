### This is tottally invalid and signs up for a PREMIUM service.

@browser = Watir::Browser.new
url = 'http://www.neustarlocaleze.biz/directory/sign-in.aspx'
@browser.goto(url)

@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_loginControl_UserName').set data['username']
@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_loginControl_Password').set data['password']

@browser.h2(:text, 'Basic Information').click
@browser.text_field(:id, 'ContentPlaceHolderMain_txtBusinessName').set data['business_name']
@browser.text_field(:id, 'ContentPlaceHolderMain_txtAddress').set data['address']
@browser.text_field(:id, 'ContentPlaceHolderMain_txtCity').set data['city']
@browser.select_list(:id, 'ContentPlaceHolderMain_ddlState').select data['state']
@browser.text_field(:id, 'ContentPlaceHolderMain_txtZip').set data['zip']
@browser.text_field(:id, 'ContentPlaceHolderMain_txtPhone').set data['phone']
@browser.text_field(:name,/txtCategory/).click
@browser.text_field(:name,'category').set data['category']

	begin
	@browser.span(:text,/#{data[ 'category' ].upcase}/).when_present.click
	@browser.link(:id,'btn-category-pop').click
	rescue
		@browser.span(:class,"name").click
		@browser.link(:id,'btn-category-pop').click
	end

@browser.link(:id, 'ContentPlaceHolderMain_btnCheckAvailability').click

Watir::Wait.until { @browser.text.include? "is available for you to claim and manage." }

@browser.select_list(:id, 'cmbPhones').option(:text, 'Toll Free Number').select
@browser.select_list(:id, 'cmbPhones').option(:text, 'Mobile Number').select
@browser.select_list(:id, 'cmbPhones').option(:text, 'Fax Number').select

@browser.text_field(:id, 'ContentPlaceHolderMain_txttollfree').set data['toll_free']
@browser.text_field(:id, 'ContentPlaceHolderMain_txtmobile').set data['mobile']
@browser.text_field(:id, 'ContentPlaceHolderMain_txtfax').set data['fax']

@browser.text_field(:id, 'ContentPlaceHolderMain_EnhancedOfficialWebsiteText').set data['website']

if data['24hour'] == true then
	@browser.radio(:id, 'ContentPlaceHolderMain_HoursOfOperationPanel_chk247').set
else
	@browser.radio(:id, 'ContentPlaceHolderMain_HoursOfOperationPanel_chkSpec').set
	count = 0
	until count > 5
	hours = data[ 'hours' ]
	hours.each_with_index do |hour, day|
		if hour[1][0] != "closed"
			# Is the day closed?	
			open = hour[1][0]
			close = hour[1][1]

			@browser.select_list( :id, "ContentPlaceHolderMain_HoursOfOperationPanel_DayRepeater_OpenList_#{count}").select open.upcase
			@browser.select_list( :id, "ContentPlaceHolderMain_HoursOfOperationPanel_DayRepeater_CloseList_#{count}").select close.upcase
		end
	count += 1
	end
end

@browser.textarea(:id, 'ContentPlaceHolderMain_PaymentMethodComboBox_CSVTextBox').click

data[ 'payments' ].each{ | pay |
    @browser.checkbox( :id => pay ).set
  }

@browser.link(:text, 'Close').click
sleep(1)
@browser.textarea(:id, 'ContentPlaceHolderMain_LanguageComboBox_CSVTextBox').click
@browser.checkbox(:id, 'ContentPlaceHolderMain_LanguageComboBox_CheckboxList_29').set
@browser.link(:text, 'Close').click
sleep(1)

@browser.text_field(:id, 'ContentPlaceHolderMain_EnhancedYearFoundedText').set data['year']

@browser.textarea(:id, 'ContentPlaceHolderMain_txtkeywords').set data['keywords']
