class Runner
  attr_reader :data

  def main(data)
    @data= data
    @brow = Watir::Browser.new :firefox

    login

    return if created_already?
    @brow.goto "http://smallbusiness.yahoo.com/local-listings/sign-up/"
    sleep(30)

    try_do :scan, 6

    if @brow.url.include?("config/login") #business_not_exists 
      txt_set({:id=> 'passwd'}, @data['yahoo_password'])
      @brow.button(:id=> '.save').click
      Watir::Wait.while{ @brow.text_field(:id => 'passwd').exists? }
    elsif @brow.url.include?("merchantsubmit/claimlisting")
      wait_for_page_load
      @brow.radios(:name=> 'listing').first.set
      Watir::Wait.until{ @brow.button(:id=> 'claim-listing-button').enabled? }
      @brow.button(:id=> 'claim-listing-button').click
    end
    try_do :register_business, 2
    #
    # because we can get control of the browser, the verify job will login and 
    # and request a verification email. 
    #
    #send_postal_mail
    #send_email
  ensure
    @brow.close if @brow
  end

  def login
    @brow.goto 'https://login.yahoo.com'
    sleep(30)
    txt_set({:id=> 'username'}, @data['yahoo_username']) 
    txt_set({:id=> 'passwd'}, @data['yahoo_password'])
    @brow.button(:id=> '.save').click
    sleep(30)
    raise 'invalid username or password' if @brow.div(:class => "yregertxt").exist?
    true
  end
 
  def created_already?
    @brow.goto "http://smallbusiness.yahoo.com/dashboard"
    sleep(45) # HMA is sloooooooow

    @brow.div(:class => "biz-info").exist? || @brow.span(:text => data['zip']).exist?
  end 

  def scan
    wait_for_page_load
    if @brow.text_field(:id => 'bizname').value != ''
      @brow.goto 'http://smallbusiness.yahoo.com/local-listings/sign-up/' 
    end
    send_keys( {:id => 'bizname'}, @data['business_name'])
    send_keys( {:id => 'phone'}, @data[ 'phone' ])
    send_keys( {:id => 'addr'}, @data[ 'address' ])
    send_keys( {:id => 'city'}, @data[ 'city' ])
    try_do :select_value, 2, {:id => 'fstate'}, @data['state' ]
    send_keys( {:id => 'zip'}, @data[ 'zip' ])
    try_do :fill_category, 1

    @brow.button(:id=> 'scannow').click
    @brow.elements(:css => "div[id*='err']").
        select{|e| e.visible?}.
        each{|e| puts "#{e.id}: #{e.text}"}
    true
  end

  def register_business
    wait_for_page_load
    Watir::Wait.until{ @brow.text_field(:name=> 'bizemail').exists? }
    puts "register business 1"
    txt_set({:name        => 'bizemail'}, @data['bizemail'])
    txt_set({:name        => 'bizurl'}, @data['bizurl'])
    @brow.checkbox(:name    => 'tos').set
    @brow.li(:id            => 'additional').click
    txt_set({:name        => 'yearestablished'}, @data['yearestablished'])
    @brow.radio(:name       => 'workduration', :value => 'DETAILED').set
    txt_set({:name        => 'addlphone'}, @data['addlphone'])
    txt_set({:name        => 'toll_free_phone'}, @data['toll_free_phone'])
    txt_set({:name        => 'fax' }, @data['fax'])
    @brow.textarea(:name    => 'products').set @data['products']
    @brow.select(:name => 'payment').options.each{|op| op.select if @data['payment'].include?(op.value) }
    ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].each do |day|
      @brow.element(:css    =>   "li[data-id='#{day}']").click
      try_do :select_value, 3, {:class=>'op-time-from'}, @data["#{day}_open"]
      try_do :select_value, 3, {:class=>'op-time-to'  }, @data["#{day}_close"]
      @brow.element( :css   =>   "[value='+ Add']").click
    end
    url= @brow.url
    @brow.button(:class     =>   'submit').click
    sleep(30)  # the browser gets stuck at this point, but the listing does get created. 
    true
  end
  
  def send_postal_mail
    @browser.goto "http://smallbusiness.yahoo.com/dashboard" 
    sleep(30)
    @browser.link(:text => "Edit").click
    sleep(30)
    @browser.checkbox(:name => "tos").set 
    sleep(5) 
    @browser.button(:text => "Submit information").click 
    sleep(30)
    @browser.radio(:id => "opt-postcard").set
    sleep(5) 
    @browser.button(:id => "btn-postcard").click
    sleep(30)
    true
  end
  def send_email
    wait_for_page_load
    @brow.radio(:id=> 'opt-email').set
    sleep(5)
    @brow.button(:id=> 'btn-email').when_present.click
    sleep(30)
    Watir::Wait.until{ @brow.a(:id=> 'mybiz-link').present? }
    true
  end

  def fill_category
    i=0
    @brow.text_field(:id => 'acseccat1').clear
    @data['category'].each_char do |char|
      @brow.text_field(:id => 'acseccat1').send_keys char
      i+=1
      sleep 2 if i > (@data['category'].length/2)
      if @brow.lis(:class=> 'yui3-aclist-item').count > 0
        @brow.element(:xpath=> "//li[@data-text='#{@data['category']}']").click
        return true
      end
    end
    false
  end

  def txt_set(selector, keys)
    keys.is_a?(String) ? @brow.text_field(selector).set(keys) : 
      @brow.text_field(selector).send_keys(keys)
    true
  end

  def send_keys(selector, keys)
    sleep 1
    if keys.is_a? String
      @brow.text_field(selector).clear
      keys.each_char{ |char| @brow.text_field(selector).send_keys(char) }
    else
      @brow.text_field(selector).send_keys(keys)
    end
  end

  def select_value selector, val
    option= @brow.select(selector).option(:value=> val)
    @brow.execute_script("return arguments[0].selected= 'selected'", option)
    Watir::Wait.until{ 
      @brow.select(selector).value == val 
    } 
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
      msg= "exhausted on retries in #{func} due to \n'#{e}' at #{@brow ? @brow.url : 'nowhere!' }"
      puts msg 
      raise msg
    end
  end

end
@heap = JSON.parse( data['heap'] ) 
puts data['heap'] 
puts "user #{data['yahoo_username']}"

runner= Runner.new
runner.main(data)

@heap['listing_created'] = true 
self.save_account("Yahoo", {"heap" => @heap.to_json, :status => "Listing created, waiting for account verification."})

if @chained
  self.start("Yahoo/Verify") 
end

true
