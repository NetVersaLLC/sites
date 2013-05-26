@browser.goto('http://www.localizedbiz.com/')


@browser.text_field( :name => 'q').set data['business']
@browser.text_field( :name => 'loc').clear

@browser.button( :name => 'Submit').click
Watir::Wait.until { @browser.text.include? "no result found" or @browser.link( :class => 'biz_title').exists? }

if @browser.text.include? "no result found"
  businessFound = [:unlisted]
elsif @browser.link( :text => /#{data['business']}/).exists?
    businessFound = [:listed,:unclaimed]
  else
    businessFound = [:unlisted]
end  

[true, businessFound]