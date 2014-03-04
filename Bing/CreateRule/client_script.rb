@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

def sign_in( data )
  @browser.goto( 'https://login.live.com/' )
  sleep(15)
 
  @browser.text_field(:name => 'login').set data['hotmail'] 
  @browser.text_field( :name => 'passwd' ).set data[ 'password' ]
  @browser.button( :name, 'SI' ).click
  sleep(15)
end

sign_in( data )
@browser.goto('mail.live.com')
sleep(30)

if @browser.link(:text => 'continue to your inbox').exist? 
  @browser.link(:text => 'continue to your inbox').click
  sleep(30)
end 
live_com = @browser.url.match(/(\Ahttps:\/\/\w*\.mail.live.com)/)[1]
@browser.goto "#{live_com}/mail/options.aspx"
sleep(30)

@browser.link( :text, /Rules for sorting new messages/i).click
@browser.button( :id, 'NewFilter').wait_until_present
@browser.button( :id, 'NewFilter').click
sleep(15)
@browser.select_list( :id, 'VerbDropDown').select "contains"
@browser.text_field( :id, 'MatchString').set "@"
@browser.button( :value, /Save/).click
sleep(15)

puts "Rule set"

if @chained
	self.start("Bing/CreateListing")
end

self.success
