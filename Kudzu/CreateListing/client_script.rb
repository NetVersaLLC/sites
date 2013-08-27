def login(data)
# Create your profile
url = 'https://register.kudzu.com/login.do'
@browser.goto(url)
30.times{ break if @browser.status == "Done"; sleep 1}
# Fill Create Your Login page
@browser.text_field( :name => 'username' ).set data[ 'userName' ]
@browser.text_field( :name => 'password' ).set data[ 'pass' ]
@browser.button( :name, 'login' ).click
30.times{ break if @browser.status == "Done"; sleep 1}
end
#Login ends
def add_personal_info(data)
# Fill Add Your Information page
prefix=data[ 'prefix' ]
if prefix == 'Miss.'
	prefix = "Ms."
elsif not prefix.nil?
	prefix = "Select Title"
end
@browser.select_list( :name => 'prefix' ).select prefix

@browser.text_field( :name => 'firstName' ).set data[ 'firstName' ]
@browser.text_field( :name => 'lastName' ).set data[ 'lastName' ]

@browser.text_field( :name => 'businessName' ).set data[ 'businessName' ]
@browser.text_field( :name => 'website' ).set data[ 'website' ]
@browser.text_field( :name => 'busAddress1' ).set data[ 'busAddress1' ]
@browser.text_field( :name => 'busAddress2' ).set data[ 'busAddress2' ]

@browser.text_field( :name => 'busCity' ).set data[ 'busCity' ]
@browser.select_list( :name, 'busState' ).select data[ 'busState' ]
@browser.text_field( :name => 'busZip1' ).set data[ 'busZip1' ]
# TODO: Don't show my address on my Kudzu.com profile?

@browser.text_field( :name => 'busNPA' ).set data[ 'busNPA' ]
@browser.text_field( :name => 'busNXX' ).set data[ 'busNXX' ]
@browser.text_field( :name => 'busPlusFour' ).set data[ 'busPlusFour' ]
@browser.text_field( :name => 'busExtension' ).set data[ 'busExtension' ]

fax=data['fax']
if not fax.nil?
	faxnpa=fax.split("-")[0]
	faxnxx=fax.split("-")[1]
	faxplusfour=fax.split("-")[2]
	@browser.text_field(:name => 'busFaxNPA' ).set faxnpa
	@browser.text_field(:name => 'busFaxNXX' ).set faxnxx
	@browser.text_field(:name => 'busFaxPlusFour' ).set faxplusfour
end
@browser.button( :name, 'nextButton' ).click
30.times { break if (begin @browser.text.include? "Choose the Correct Address" rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }
rescue => e
  unless @retries == 0
    puts "Error caught in listing creation: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught in listing creation could not be resolved. Error: #{e.inspect}"
  end
 end
 #add_personal_info(data) ends
 def finish_creation(data)
# Confirm on Choose the Correct Address page
if @browser.text.include? "Choose the Correct Address"
@browser.button( :name, 'nextButton' ).click
end

30.times{ break if @browser.status == "Done"; sleep 1}

# Select on Choose Category page
@browser.select_list( :id, 'industry' ).select /#{data[ 'industry' ]}/

30.times { break if (begin @browser.select_list( :id, 'category' ).exists? rescue Selenium::WebDriver::Error::NoSuchElementError end) == true; sleep 1 }

@browser.select_list( :id, 'category' ).select /#{data[ 'category' ]}/
@browser.button( :name, 'nextButton' ).click

30.times{ break if @browser.status == "Done"; sleep 1}
@browser.button( :name, 'nextButton' ).click

#
30.times{ break if @browser.status == "Done"; sleep 1}

count=[1,2,3,4,5]
count.each do |i|
if @browser.button( :name, 'nextButton' ).present?
	@browser.button( :name, 'nextButton' ).click
else
	break
end
count -= 1
end
#

# On Add Specialties page
# TODO: Steps 1, 2, 3, 4, but probably may vary (N of 4)

# On Preview Your Profile
@browser.checkbox( :name, 'businessAgreement' ).set
@browser.button( :name, 'submitButton' ).click

30.times{ break if @browser.status == "Done"; sleep 1}

puts("Business SingUp Success!")

rescue => e
  unless @retries == 0
    puts "Error caught in listing creation: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error caught in listing creation could not be resolved. Error: #{e.inspect}"
  end
 end
 #finish_creation ends.
 
def chain_next
if @chained
  self.start("Kudzu/Verify")
end
end
@retries=2
login(data)
add_personal_info(data)
finish_creation(data)
chain_next
true

#Basic profile details updated!