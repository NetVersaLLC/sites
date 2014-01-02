@browser = Watir::Browser.new :firefox
at_exit{
    unless @browser.nil?
        @browser.close 
    end
}

def login ( data )
  site = 'https://plus.google.com/local'
  @browser.goto site
  
  if !!@browser.html['Recommended places']
    return true # Already logged in
  end
  
  page = Nokogiri::HTML(@browser.html)

  #if not page.at_css('div.signin-box') # Check for <div class="signin-box">
  #  @browser.link(:text => 'Sign in').click
  #end

  if !data['email'].empty? and !data['pass'].empty?
    @browser.text_field(:id, "Email").set data['email']
    @browser.text_field(:id, "Passwd").set data['pass']
    @browser.button(:value, "Sign in").click
    sleep(5)
    # If user name or password is not correct
      if @browser.span(:id => 'errormsg_0_Passwd').exist?
        if @browser.span(:id => 'errormsg_0_Passwd').visible?
        end
      elsif !!@browser.html['Join Google+ by creating your public profile']
        @browser.div(:text, /Upgrade/).click
        @browser.div(:text, /Continue/).click
        sleep 5
        @browser.div(:text, /Continue/).click
        @browser.button(:text, /Continue anyway/).when_present.click
        @browser.div(:text, /Finish/).click
      end
  else
    raise StandardError.new("You must provide both a username AND password for gplus_login!")
  end
end

def search_for_business( data )

  puts 'Search for the ' + data[ 'business' ] + ' business at ' + data[ 'zip' ] + data['city']

  #Close pop up if exist
  if @browser.div(:class => 'U-L-Y U-L-Y-tm').button(:name => 'continue').exist? and @browser.div(:class => 'U-L-Y U-L-Y-tm').button(:name => 'continue').visible?
    @browser.div(:class => 'U-L-Y U-L-Y-tm').button(:name => 'continue').click
  end

  #Upgrade the account
  if @browser.div(:class => 'BSa TVa').exist? && @browser.div(:class => 'BSa TVa').visible?
     @browser.div(:class => 'BSa TVa').click
     if @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').exist? && @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').visible?
     @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').when_present.click until @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').exist? == false
     end
  end

  # 'https://plus.google.com/local' ) # Must be logged in to search
  @browser.goto('https://plus.google.com/local')
  @browser.text_field(:name, "qc").when_present.set data['business']
  @browser.text_field(:name, "qb").when_present.set data['city']
  @browser.button(:id,'gbqfb').when_present.click
  @browser.wait_until { @browser.text.include?('Loading...') == false}
  #@browser.wait_until { @browser.span(:text =>'Key to ratings').exist? == true}
end

def parse_results( data )
  #Parse search result page
  page = Nokogiri::HTML(@browser.html)
  page_links = page.css("a").select
  applicableLinks = {}
  page_links.each do |link|
   if not link.nil?
     if not link['href'].nil? and !!link['href']["/about"]
       img = ""
       if not link.at('img').nil?
         img = link.at('img')['src']
       end
       applicableLinks[link.content] = [link['href'], img]
     end
   end
  end
  return applicableLinks.to_a
end

def discern_parse_business_exist?( applicableLinks, data )
	return applicableLinks.collect { |listing| listing[0] == data['business'] }.member?(true)
end

login( data )
search_for_business( data )
matching_result = discern_parse_business_exist?( parse_results( data ), data )

if matching_result == true
  self.start("Google/ClaimListing")
else
  self.start("Google/CreateListing")
end
