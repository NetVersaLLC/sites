class Runner
  attr_reader :data

  def main(data)
    @data= data
    @brow = Watir::Browser.new :firefox
    try_do :login, 2
    try_do :claim, 3
    try_do :check_results, 2
    if @brow.url.start_with?("https://foursquare.com/venue/claim?venuename")
      try_do :add_venue, 2
      try_do :claim_venue, 2
    else
      # @self.start('Foursquare/ClaimListing')
    end
  ensure
    @brow.close if @brow
  end
  
  def login
    @brow.goto 'https://foursquare.com/login'
    txt_set({:id=> 'username'}, @data['email'])
    txt_set({:id=> 'password'}, @data['password'])
    @brow.button(:id=> 'loginFormButton').click
    Watir::Wait.while{ @brow.button(:id=> 'loginFormButton').exists? }
    wait_for_page_load
    true
  end
  
  def add_venue
    wait_for_page_load
    txt_set({:id => 'venueAddress_field'}, @data['address'])
    txt_set({:id => 'venueZip_field'}, @data['zip'])
    dispatch_event({:id=> 'venueAddress_field'}, 'blur')
    txt_set({:id => 'venueTwitterName_field'}, @data['twitter_page'])
    txt_set({:id => 'venuePhone_field'}, @data['phone'])
    select_text({:name => 'topLevelCategory'}, @data['category1'])
    @brow.select_list(:name => 'topLevelCategory').click
    Watir::Wait.until{ @brow.select_list(:name => 'secondLevelCategory').present? }
    select_text({:name => 'secondLevelCategory'}, @data['category2'])
    # select_text({:name => 'thirdLevelCategory'}, @data['category3'])
    try_do :set_map, 2
    @brow.button(:value=> 'Save').click
    Watir::Wait.while{ @brow.button(:value=> 'Save').present? }
    true
  end
  
  def set_map
    if @brow.hidden(:name=>'geolng').value + @brow.hidden(:name=>'geolat').value == ''
      zoom= @brow.execute_script('return map._zoom;')
      if zoom < 16
        @brow.execute_script("setTimeout(function(){
          if(map._zoom < 16)
            map.zoomIn();
          }, 1000)")
        #@brow.link(:title => "Zoom in").click
      end
      sleep 5
      @brow.images(:class => 'leaflet-tile leaflet-tile-loaded').first.click          
      sleep 5
    end
    @brow.hidden(:name=>'geolng').value + @brow.hidden(:name=>'geolat').value != ''
  end
  
  def claim_venue   
    @brow.checkbox(:id => 'agree').set
    @brow.span(:class => 'continueButton greenButton biggerButton').click
    Watir::Wait.until{ @brow.element(:id=> 'phoneField').exists? }
    txt_set({:id => 'phoneField'}, @data['mobile'])
    @brow.span(:class => 'continueButton greenButton biggerButton').click
    Watir::Wait.until{ @brow.text_field(:id=> 'phoneField').value.length == 4 }
    PhoneVerify.send_code("Foursquare", @brow.text_field(:id=> 'phoneField').value)
    Watir::Wait.until{ @brow.element(:id=> 'option2').exists? }
    @brow.radio(:id=> 'option2').set
    @brow.a(:text=> /Mail me/).click
  end
  
  def check_results
    wait_for_page_load
    @brow.execute_script('return document.getElementsByClassName("addVenueLink")[0].click();')
    Watir::Wait.while{ @brow.a(:class=> 'addVenueLink').exists? }
    wait_for_page_load
    true
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
  
  def txt_set(selector, keys)
    keys.is_a?(String) ? @brow.text_field(selector).set(keys) : 
      @brow.text_field(selector).send_keys(keys)
    true
  end

  def select_text selector, val
    elem= @brow.select(selector)
    @brow.execute_script("
    var ops= arguments[0].options;
    for(var i=0; i< ops.length; i++)
      if(ops[i].text=='#{val}')
        ops[i].selected=true;
    var event = new Event('change');
    arguments[0].dispatchEvent(event);", elem)
        
    Watir::Wait.until{ 
      @brow.select(selector).selected_options[0].text == val 
    } 
    true
  end
  
  def dispatch_event selector, event
    elem= @brow.element(selector)
    @brow.execute_script("var e= new Event('#{event}');arguments[0].dispatchEvent(e);", elem)
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
      msg= "exhauseted on retries in #{func} due to \n'#{e}'"
      puts msg 
      raise msg
    end
  end

end

runner= Runner.new
runner.main(data)

sleep 2
if @chained
  self.start("Foursquare/Verify")
  self.start("Foursquare/AddListing")
end
true