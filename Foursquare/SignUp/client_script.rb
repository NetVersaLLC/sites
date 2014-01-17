class Runner
  attr_reader :data

  def main(data)
    @data= data
    @brow = Watir::Browser.new :firefox
    try_do :claim, 3
    try_do :check_results, 2
    try_do :signup, 3
  ensure
    @brow.close if @brow
  end
  
  def claim
    claim_url= 'https://foursquare.com/venue/claim'
    @brow.goto claim_url
    txt_set({:name=> 'query'}, @data['business_name'])
    txt_set({:name=> 'location'}, "#{@data['city']}, #{@data['state']}")
    @brow.button(:id=> 'searchButton').click
    @brow.execute_script("window.scrollBy(0,1000)")
    wait_for_page_load
    @brow.execute_script("window.scrollBy(0,1000)")
    sleep 5
    Watir::Wait.until{ @brow.a(:class=> 'addVenueLink').exists? }
    true
  end

  def check_results
    wait_for_page_load
    @brow.execute_script('return document.getElementsByClassName("addVenueLink")[0].click();')
    Watir::Wait.while{ @brow.a(:class=> 'addVenueLink').exists? }
    wait_for_page_load
    true
  end
  
  def signup
    wait_for_page_load
    txt_set({:id => 'inputEmail'}, @data['email'])
    txt_set({:id => 'inputPassword'}, @data['password'])
    txt_set({:id => 'inputFirstName'}, @data['first_name'])
    txt_set({:id => 'inputLastName'}, @data['last_name'])
    txt_set({:name => 'birthMonth'}, @data['birth_month'])
    txt_set({:id => 'inputBirthDate'}, @data['birth_day'])
    txt_set({:name => 'birthYear'}, @data['birth_year'])
    @brow.radio(:name=> 'gender', :value=> @data['gender']).set
    @brow.button(:value => 'Sign Up').click
    Watir::Wait.while{ @brow.text_field(:id => 'inputEmail').exists? }
    true
  end
  
  def txt_set(selector, keys)
    keys.is_a?(String) ? @brow.text_field(selector).set(keys) : 
      @brow.text_field(selector).send_keys(keys)
    true
  end
  
  def wait_for_page_load
    Watir::Wait.until{ @brow.execute_script("return document.readyState == 'complete';")}
  end

  def try_do func, n, *args
    retries= 0
    begin
      if result= self.send(func, *args)
        return result
      end
      puts  "retrying #{func}"
      raise "retrying #{func}"
    rescue Exception => e
      retries+=1
      retry if retries< n
      msg= "exhauseted on retries in #{func} due to \n'#{e}' at #{@brow ? @brow.url : 'nowhere!' }"
      puts msg 
      raise msg
    end
  end

end
 
runner= Runner.new
runner.main(data)
data= runner.data
true

self.save_account("Foursquare", {:email => data['email'],:password => data['password']})
sleep 2
if @chained
	self.start("Foursquare/Verify")
  self.start("Foursquare/AddListing")
end
true