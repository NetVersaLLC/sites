@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close
    end
}

unless data['link'].nil?
  @browser.goto(data['link'])
  sleep 2
  Watir::Wait::until{@browser.text.include? "Account Activation"}
  @browser.text_field(:name => 'txtPassword').set data['password']
  @browser.button(:text => "Activate").click
  sleep 15
  if @chained
    self.start("Showmelocal/AddListing")
  end
else
  if @chained
    self.start("Showmelocal/Verify", 1440)
  end
end