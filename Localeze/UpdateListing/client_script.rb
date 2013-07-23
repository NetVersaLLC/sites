@browser = Watir::Browser.new
url = 'http://www.neustarlocaleze.biz/directory/sign-in.aspx'
@browser.goto(url)

@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_loginControl_UserName').set data['username']
@browser.text_field(:id, 'ctl00_ContentPlaceHolderMain_loginControl_Password').set data['password']