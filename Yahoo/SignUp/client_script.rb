
class Runner
  attr_reader :data

  def main(data)
    @data= data
    @brow = Watir::Browser.new :firefox
    try_do :scan, 3
    signup
    wait_for_page_load
    if @brow.element(:css => '#timer-message a').exists?
       @brow.element(:css => '#timer-message a').click            
       wait_for_page_load       
    else
       phone_verify
       code = PhoneVerify.retrieve_code("Yahoo")
       input_verification_sms(code)
    end
    register_business
    @brow.close if @brow
  end

  def input_verification_sms(code)
    wait_for_page_load
    send_keys({:id => 'verification-code'}, code.to_s)
    @brow.button(:type => 'submit').click
  end

  def register_business
    wait_for_page_load
    send_keys({:name        => 'bizemail'}, @data['bizemail'])
    send_keys({:name        => 'bizurl'}, @data['bizurl'])
    @brow.checkbox(:name    => 'tos').set
    @brow.li(:id            => 'additional').click
    send_keys({:name        => 'yearestablished'}, @data['yearestablished'])
    @brow.radio(:name       => 'workduration', :value => 'DETAILED').set
    send_keys({:name        => 'addlphone'}, @data['addlphone'])
    send_keys({:name        => 'toll_free_phone'}, @data['toll_free_phone'])
    send_keys({:name        => 'fax' }, @data['fax'])
    @brow.textarea(:name    => 'products').set @data['products']
    @brow.select_list(:name => 'payment').options.each{|op| op.select if @data['payment'].include?(op.value) }
    ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].each do |day|
      @brow.element(:css    =>   "li[data-id='#{day}']").click
      try_do :select_value, 2, {:class=>'op-time-from'}, @data["#{day}_open"]
      try_do :select_value, 2, {:class=>'op-time-to'  }, @data["#{day}_close"]
      @brow.element( :css   =>   "[value='+ Add']").click
    end
    @brow.button(:class     =>   'submit').click
  end

  def scan
    @brow.goto('http://smallbusiness.yahoo.com/local-listings/sign-up/')
    wait_for_page_load
    @brow.execute_script("jQuery('form[name=\\'msb\\']').trigger('reset');")
    send_keys( {:id => 'bizname'}, @data['business_name'])
    send_keys( {:id => 'phone'}, @data[ 'phone' ])
    send_keys( {:id => 'addr'}, @data[ 'address' ])
    send_keys( {:id => 'city'}, @data[ 'city' ])
    try_do :select_value, 2, {:id => 'fstate'}, @data['state' ]
    send_keys( {:id => 'zip'}, @data[ 'zip' ])

    try_do :fill_category, 5

    @brow.button(:id=> 'scannow').click
    @brow.elements(:css => "div[id*='err']").
        select{|e| e.visible?}.
        each{|e| puts "#{e.id}: #{e.text}"}
    #if redirect to signup
    if true
      wait_for_page_load
      @brow.a(:id=> 'signUpBtn').wait_until_present(20)
      @brow.a(:id=> 'signUpBtn').click
      #if redirec to claim listing
    else

    end
    true
  end

  def send_keys(selector, keys)
    sleep 5 until @brow.text_field(selector).exists?
    if keys.is_a? String
      @brow.text_field(selector).clear
      keys.each_char do |char|
        @brow.text_field(selector).send_keys char
        sleep 0.1
      end
    else
      @brow.text_field(selector).send_keys keys
    end

    @brow.text_field(selector).send_keys :tab

    @brow.text_field(selector)
  end


  def select_value selector, val
    @brow.select_list(selector).select_value(val)
    @brow.select_list(selector).send_keys :tab
    @brow.select_list(selector).selected_options.first.value == val
  end

  def fill_category
    i=0
    @brow.text_field(:id => 'acseccat1').clear
    @data['category'].each_char do |char|
      @brow.text_field(:id => 'acseccat1').send_keys char
      i+=1
      sleep 2 if i > 3
      if @brow.lis(:class=> 'yui3-aclist-item').count > 0 and i >= 5
        @brow.lis(:class=> 'yui3-aclist-item').first.click
        return true
      end
    end
    false
  end

  def signup
    wait_for_page_load
    send_keys({:name=> 'firstname'},       @data['firstname'])
    send_keys({:name=> 'secondname'},      @data['lastname'])

    try_do :make_yahoo_id, 3

    send_keys({:name=> 'password'},        @data['password'])
    send_keys({:name=> 'mobileNumber'},    @data['mobile'])
    try_do :select_value, 2, {:id=> 'year'},  @data['birthday'][0..3].to_s
    try_do :select_value, 2, {:id=> 'month'}, @data['birthday'][5..6].to_i.to_s
    try_do :select_value, 2, {:id=> 'day'},   @data['birthday'][8..9].to_i.to_s
    @brow.radio(:name=> 'gender',:value => @data['gender']).set
    @brow.button(:type => 'submit').click
  end

  def make_yahoo_id
    wait_for_page_load false
    i=0
    until @brow.execute_script("return jQuery('#suggestions li').length;") >= 1
      sleep 1 if i<5
      i+=1
    end
    ids= @brow.execute_script <<-JS
     return jQuery('#suggestions li').map(function(){return jQuery(this).text();}).get();
    JS
    @data['username']= (ids.empty? ? nil : ids[0]) || (@data['username']+(rand(2**15)%941).to_s)
    send_keys({:name=> 'yahooid'}, @data['username'])
    send_keys({:name=> 'yahooid'}, :tab)
    wait_for_page_load false
    @brow.p(:id => 'user-name-validation-message').text.strip == ""
  end

  def phone_verify
    wait_for_page_load
    send_keys({:id => 'mobile'}, @data['verification_mobile'])
    @brow.execute_script <<-script
      return jQuery('#country-code option:first')
               .attr('value', '#{@data['verification_country_code']}')
               .attr('data-country-code', '#{@data['verification_country']}')
               .attr('selected', 'selected').val();
    script
    @brow.button(:type => 'submit').click
  end

  def wait_for_page_load with_jquery= true
    until @brow.execute_script("return document.readyState == 'complete';")
      sleep 1
    end
    inject_jquery if with_jquery
  end

  def try_do func, n, *args
    retries= 0
    begin
      if result= self.send(func, *args)
        return
      end
      puts  "retrying #{func}"
      raise "retrying #{func}"
    rescue Exception => e
      retries+=1
      retry if retries< n
      puts  "exhauseted on retries in #{func} due to #{e}"
      raise "exhauseted on retries in #{func} due to #{e}"
    end
  end

  def inject_jquery
    @brow.execute_script <<-JS
      (function(){var el=document.createElement('div'),b=document.getElementsByTagName('body')[0],otherlib=false,msg='';el.style.position='fixed';el.style.height='32px';el.style.width='220px';el.style.marginLeft='-110px';el.style.top='0';el.style.left='50%';el.style.padding='5px 10px';el.style.zIndex=1001;el.style.fontSize='12px';el.style.color='#222';el.style.backgroundColor='#f99';if(typeof jQuery!='undefined'){msg='This page already using jQuery v'+jQuery.fn.jquery;return showMsg()}else if(typeof $=='function'){otherlib=true}function getScript(url,success){var script=document.createElement('script');script.src=url;var head=document.getElementsByTagName('head')[0],done=false;script.onload=script.onreadystatechange=function(){if(!done&&(!this.readyState||this.readyState=='loaded'||this.readyState=='complete')){done=true;success();script.onload=script.onreadystatechange=null;head.removeChild(script)}};head.appendChild(script)}getScript('https://code.jquery.com/jquery.min.js',function(){if(typeof jQuery=='undefined'){msg='Sorry, but jQuery wasnt able to load'}else{msg='This page is now jQuerified with v'+jQuery.fn.jquery;if(otherlib){msg+=' and noConflict(). Use $jq(), not $().'}}return showMsg()});function showMsg(){el.innerHTML=msg;b.appendChild(el);window.setTimeout(function(){if(typeof jQuery=='undefined'){b.removeChild(el)}else{jQuery(el).fadeOut('slow',function(){jQuery(this).remove()});if(otherlib){$jq=jQuery.noConflict()}}},2500)}})();
    JS
    until @brow.execute_script('return !!window.jQuery')
      sleep 1
    end
  end
end

runner= Runner.new
runner.main(data)
data= runner.data
self.save_account('Yahoo',  {:email => data['username'],:password => data['password']})
true
