
class Runner
  attr_reader :data

  def main(data)
    @data= data
    @brow = Watir::Browser.new :firefox
    try_do :verify, 3
  ensure
    @brow.close if @brow
  end
  
  def verify
    @brow.goto(data['url'])
    txt_set({:id => 'password'}, @data['password'])
    @brow.button(:id=> 'loginFormButton').click
    wait_for_page_load
    Watir::Wait.while{ @brow.button(:id=> 'loginFormButton').exists? }
    sleep 5
    Watir::Wait.until{ @brow.url.incldue?('https://foursquare.com/download') }
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
true