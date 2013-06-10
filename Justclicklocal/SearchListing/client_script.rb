@browser = Watir::Browser.new
@browser.goto('http://www.justclicklocal.com/')
@browser.text_field( :name => 'query').set data['business']
@browser.text_field( :name => 'location').set data['citystate']

@browser.button(:id => 'submit').click


Watir::Wait.until { @browser.div(:class => 'initialresults').exists? or @browser.text.include? "Your search term returned no results"}
  if @browser.link( :text => /#{data['business']}/).exists?
     businessFound = [:listed, :unclaimed]
  else
     businessFound = [:unlisted] 
  end

at_exit do @browser.close end

[true, businessFound]