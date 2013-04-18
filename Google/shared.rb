def login ( data )
  site = 'https://plus.google.com/local'
  @browser.goto site
  
  if !!@browser.html['Recommended places']
    return true # Already logged in
  end
  
  page = Nokogiri::HTML(@browser.html)

  if not page.at_css('div.signin-box') # Check for <div class="signin-box">
    @browser.link(:text => 'Sign in').click
  end

  if !data['email'].empty? and !data['pass'].empty? 
    @browser.text_field(:id, "Email").set data['email']
    @browser.text_field(:id, "Passwd").set data['pass']
    @browser.button(:value, "Sign in").click
    sleep(5)
    # If user name or password is not correct
      if @browser.span(:id => 'errormsg_0_Passwd').exist?
        if  @browser.span(:id => 'errormsg_0_Passwd').visible?
 	  signup_generic( data )
        end
      end
  else
    raise StandardError.new("You must provide both a username AND password for gplus_login!")
  end
end

def search_for_business( data )

	puts 'Search for the ' + data[ 'business' ] + ' business at ' + data[ 'zip' ] +  data['city']
	
	#Close pop up if exist
	if @browser.div(:class => 'U-L-Y U-L-Y-tm').exist? and @browser.div(:class => 'U-L-Y U-L-Y-tm').visible?
           if @browser.button(:name => 'continue').exist?
	     @browser.button(:name => 'continue').click
	   end 
	end

        #Upgrade the account
        if @browser.div(:class => /BSa TVa/).exist?
          @browser.div(:class => /BSa TVa/).click
          @browser.div(:class=> 'a-f-e c-b c-b-M YY Tma').click
          @browser.button(:name => 'continue').click
          @browser.div(:class=> /a-f-e c-b c-b-M/).click
          @browser.button(:name => 'continue').click
        end
	
	# 'https://plus.google.com/local' ) # Must be logged in to search
	@browser.goto('https://plus.google.com/local')
	@browser.text_field(:name, "qc").set data['business']
	@browser.text_field(:name, "qb").set data['city']
	@browser.button(:id,'gbqfb').click
	@browser.wait
	sleep(5)
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

def retry_captcha(data)
  capSolved = false
  count = 1
  until capSolved or count > 5 do
    captcha_text = solve_captcha	
    @browser.text_field(:id, "Passwd").value = data['pass']
    @browser.text_field(:id, "PasswdAgain").value = data['pass']
    @browser.text_field( :id => 'recaptcha_response_field' ).set captcha_text
    @browser.checkbox(:id => 'TermsOfService').set
    @browser.button(:value, 'Next step').click

     sleep(5)
    if not @browser.text.include? "The characters that you entered didn't match the word verification"
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

def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\google_captcha.png"
  obj = @browser.image(:src, /recaptcha\/api\/image/)
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  captcha_text = CAPTCHA.solve image, :manual
  return captcha_text
end
