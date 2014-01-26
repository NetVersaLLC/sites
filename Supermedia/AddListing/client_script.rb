@browser = Watir::Browser.new :firefox
at_exit do
  unless @browser.nil?
    @browser.close
  end
end

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\supermedia_captcha.png"
  obj = @browser.img( :xpath, '//*[@id="captchimgid"]' )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end

def enter_captcha( data )

        capSolved = false
        count = 1
        until capSolved or count > 5 do
                captcha_code = solve_captcha
                @browser.text_field( :id, 'captchaRes').set captcha_code
                @browser.link( :text => 'continue').click

                sleep(2)
                if not @browser.text.include? "Please try again. Entry did not match display."
                        capSolved = true
                end
        count+=1
        end
        if capSolved == true
                true
        else
                throw("Captcha was not solved")
        end
end

@browser.goto('http://www.supermedia.com/spportal/quickbpflow.do')

@browser.text_field( :name => 'phone').set data['phone']
@browser.link( :id => 'getstarted-search-btn').click

Watir::Wait.until {
  @browser.link( :text => 'select' ).visible?
}
@browser.links( :text => 'select' ).last.click
@browser.link( :text => 'next', :index => 0 ).when_present.click

@browser.text_field( :id => 'busname').set data['business']
@browser.text_field( :id => 'address1Id').set data['addressComb']
@browser.text_field( :id => 'cityId').set data['city']
@browser.select_list( :id => 'stateId').select data['state']
@browser.text_field( :id => 'zipId').set data['zip']
@browser.text_field( :id => 'wsurl').set data['website']
@browser.text_field( :id => 'searchtext').set data['category1']
@browser.link( :text => 'search').click
@browser.span( :class => 'addlink', :index => 0).when_present.click

@browser.text_field( :name => 'customerProfile.firstname').set data['fname']
@browser.text_field( :name => 'customerProfile.lastname').set data['lname']
@browser.text_field( :id => 'account-email').set data['email']
@browser.text_field( :id => 'emailconfirm').set data['email']

enter_captcha( data )

@browser.checkbox( :id => 'acceptterms').when_present.click
@browser.link(:id => 'popup_ok').click

sleep(5)
  RestClient.post "#{@host}/accounts.json?auth_token=#{@key}&business_id=#{@bid}", 'account[username]' => data['email'], 'model' => 'Supermedia'

  if @chained
    self.start("Supermedia/Verify")
  end
true

