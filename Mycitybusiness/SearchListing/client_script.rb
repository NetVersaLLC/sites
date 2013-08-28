require 'rubygems'
require 'mechanize'
businessFound = {}

agent = Mechanize.new

page = agent.get('http://www.mycitybusiness.net/search.php')

search_form = page.form('quick_search_form')
search_form.kword = data['business']
search_form.city = data['city']
results = agent.submit(search_form)
if results.search('strong')[3].text == data['business'] then
  puts("Business is listed")
  businessFound['status'] = :claimed
  businessFound['listed_address'] = results.search('td')[31].text + results.search('td')[32].text.strip
  businessFound['listed_phone'] = results.search('td')[34].text
else
  puts("Business is unlisted")
  businessFound['status'] = :unlisted
end

[true, businessFound]
=begin
@browser.text_field(:id => 'kword').set data['last_name'] #data['business']
@browser.text_field(:id => 'city').set data['city']
@browser.select_list(:name => 'state').select_value data['state_short']
@browser.link(:xpath => '//*[@id="quick_search_form"]/div/a[2]').click
sleep(3)
Watir::Wait.until { @browser.text.include? "Searching for" }

if @browser.text.include? "0 Results"
  businessFound['status'] = :unlisted
else
  if @browser.text.include? data['last_name'] #data['business']
    businessFound['status'] = :listed
    businessFound['listed_address'] = @browser.element(:xpath => "//table[@width='786']//table//td[@style='margin-left:11px;']//tr[1]").text
    businessFound['listed_address2'] = @browser.element(:xpath => "//table[@width='786']//table//td[@style='margin-left:11px;']//tr[2]").text
    businessFound['listed_phone'] = @browser.element(:xpath => "//table[@width='786']//table//td[@style='vertical-align:top;'][1]").text
    businessFound['listed_email'] = @browser.element(:xpath => "//table[@width='786']//table//td[@style='vertical-align:top;']//table//tr[1]/td").text
    businessFound['listed_url'] = @browser.element(:xpath => "//table[@width='786']//table//td[@style='vertical-align:top;']//table//tr[2]/td").text
  else
    businessFound['status'] = :unlisted
  end  
end
=end