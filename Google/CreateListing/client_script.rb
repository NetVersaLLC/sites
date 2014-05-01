#require 'rautomation'

#!/usr/bin/env ruby

require 'rubygems'
require 'ffi'

module Win
  extend FFI::Library

  ffi_lib 'user32'
  ffi_convention :stdcall

  # BOOL CALLBACK EnumWindowProc(HWND hwnd, LPARAM lParam)
  callback :enum_callback, [ :pointer, :long ], :bool

  # BOOL WINAPI EnumDesktopWindows(HDESK hDesktop, WNDENUMPROC lpfn, LPARAM lParam)
  attach_function :enum_desktop_windows, :EnumDesktopWindows,
                  [ :pointer, :enum_callback, :long ], :bool

  # BOOL WINAPI EnumWindows( WNDENUMPROC lpEnumFunc, LPARAM lParam )
  attach_function :enum_windows, :EnumWindows,
    [ :enum_callback, :long ], :bool

  # DWORD WINAPI GetWindowThreadProcessId( HWND hWnd, LPDWORD lpdwProcessId )
  attach_function :get_window_thread_process_id, :GetWindowThreadProcessId,
    [ :pointer, :pointer ], :long

  # HDESK WINAPI OpenDesktop(                      
  # _In_  LPTSTR lpszDesktop,                      
  # _In_  DWORD dwFlags,                           
  # _In_  BOOL fInherit,                           
  # _In_  ACCESS_MASK dwDesiredAccess              
  # );                                             
                                                          
  attach_function :open_desktop, :OpenDesktopA, [  
    :pointer,                                      
    :ulong,                                        
    :bool,                                         
    :ulong], :pointer                              

  # int GetWindowTextA(HWND hWnd, LPTSTR lpString, int nMaxCount)
  attach_function :get_window_text, :GetWindowTextA,
                  [ :pointer, :pointer, :int ], :int

  # int WINAPI GetClassName(                        
  # _In_   HWND hWnd,                               
  # _Out_  LPTSTR lpClassName,                      
  # _In_   int nMaxCount                            
  # );                                              
                                                          
  attach_function :get_class_name, :GetClassNameA, [
    :pointer,                                       
    :pointer,                                       
    :int], :int

  # HWND WINAPI GetDlgItem(
  #     _In_opt_  HWND hDlg,
  #         _In_      int nIDDlgItem
  # );

  attach_function :get_dlg_item, :GetDlgItem, [:pointer, :long], :pointer

  # LRESULT WINAPI SendMessage(                    
  #  _In_  HWND hWnd,                              
  # _In_  UINT Msg,                                
  # # _In_  WPARAM wParam,                           
  # # _In_  LPARAM lParam                            
  # # );                                             
  attach_function :send_message, :SendMessageA, [  
    :pointer,
    :uint,
    :long,
    :pointer], :pointer

  # BOOL WINAPI PostMessage(
  #   _In_opt_  HWND hWnd,
  #     _In_      UINT Msg,
  #     _In_      WPARAM wParam,
  #   _In_      LPARAM lParam
  # );
  attach_function :post_message, :PostMessageA, [  
    :pointer,
    :uint,
    :long,
    :long], :bool


  Win::WM_SETTEXT = 12

  def self.find_upload_window(window_name = 'File Upload')
    win_count = 0
    title = FFI::MemoryPointer.new :char, 512
    class_name = FFI::MemoryPointer.new :char, 512

    handles = []
    enumWindowCallback = Proc.new do |wnd, param|
      title.clear
      Win.get_window_text(wnd, title, title.size)
      Win.get_class_name(wnd, class_name, class_name.size)
      if title.get_string(0) == window_name
        puts "[%03i] Found '%s' of class '%s'" % [ win_count += 1, title.get_string(0), class_name.get_string(0) ]
        pid = FFI::MemoryPointer.new :long, 1
        Win.get_window_thread_process_id wnd, pid
        if class_name.get_string(0) == '#32770'
          handles.push wnd
        end
        puts "Process id: #{pid.get_long(0)}"
      end
      true
    end
    @desktop_name = 'citation'
    @desktop_handle = Win.open_desktop(@desktop_name, 1, false, 268435456)
    Win.enum_desktop_windows(@desktop_handle, enumWindowCallback, 0)
    Win.enum_windows(enumWindowCallback, 0)
    title.free
    class_name.free
    return handles.first
  end
  def self.set_upload(file, window_name='File Upload')
    fp = FFI::MemoryPointer.from_string(file)
    wnd = Win.find_upload_window(window_name)
    text_area = Win.get_dlg_item(wnd, 1148)
    ret = Win.send_message(text_area, Win::WM_SETTEXT, 0, fp)
    open_button = Win.get_dlg_item(wnd, 1)
    Win.post_message(open_button, 245, 0, 0)
  end
end

# Used for proper exception handling

class InvalidDashboard < StandardError
end

@browser = Watir::Browser.new :firefox
at_exit{
  unless @browser.nil?
    @browser.close 
  end
}

def solve_captcha()
  image = "#{ENV['USERPROFILE']}\\citation\\google_captcha.png"
  obj = @browser.img( :src, /Captcha/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image
  CAPTCHA.solve image, :manual
end

def login ( data )
  site = 'https://www.google.com/local/business'
  @browser.goto site
  
  if !!@browser.html['Recommended places']
    puts "Already Logged in?"
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
    until not @browser.text.include? "Letters are not case-sensitive"
      puts "Captcha detected"
      unless @retries == 0
        @retries -= 1
        #@browser.text_field(:id, "Email").set data['email']
        @browser.text_field(:name, "Passwd").set data['pass']
        @browser.text_field(:id, 'logincaptcha').set solve_captcha
        @browser.button(:value, "Sign in").click 
      else
        raise "Could not solve Captcha"
      end
    end
    # If user name or password is not correct
      if @browser.span(:id => 'errormsg_0_Passwd').exist?
        if @browser.span(:id => 'errormsg_0_Passwd').visible?
          raise "Incorrect password"
        end
      end
  else
    raise StandardError.new("You must provide both a username AND password for gplus_login!")
  end
rescue
  unless @retries == 0
    @retries -= 1
    retry
  end
end

# No longer used, left for reference
# Upload photo on google profile
def photo_upload_pop(data)
  require 'rautomation'
  #update logo
  @browser.div(:class => 'G8iV4').when_present.click
  @browser.div(:class => /o7Daxc g-s-Sa-Cr/).when_present.click
  @browser.div(:text => 'Select a photo from your computer').when_present.click
  data['logo'] = self.logo
  if data['logo'] > 0
    photo_upload_pop = RAutomation::Window.new :title => /File Upload/
    photo_upload_pop.text_field(:class => "Edit").set(data['logo'])
    photo_upload_pop.button(:value => "&Open").click
    @browser.wait_until {@browser.div(:text => 'Set as profile photo').visible? }
    @browser.div(:text => 'Set as profile photo').click
    @browser.button(:value => 'Cancel').when_present.click
  end

  #update other images
  pic = self.images
  data[ 'images' ] = pic
  @browser.div(:text => 'Change cover').when_present.click
  @browser.div(:text => 'Upload').when_present.click
  @browser.div(:text => 'Select a photo from your computer').when_present.click
  if pic.length > 0
    image_index = ""
    for image_index in (0..pic.length-1)
      photo_upload_pop = RAutomation::Window.new :title => /File Upload/
      photo_upload_pop.text_field(:class => "Edit").set(pic[image_index])
      photo_upload_pop.button(:value => "&Open").click
      @browser.wait_until {@browser.div(:text => 'Select cover photo').visible? }
      @browser.div(:text => 'Select cover photo').click
    end
  end
end


# Used to handle different elements later down the road
def check_scenarios( data )
  businessFound = false
  business_name = []
  address = []
  data['business'].split(" ").each{ |word|
    business_name.push(word)
  }
  weight = 0
  puts "Checking result scenarios..."
  # Check for different scenarios
  if @browser.text.include? "Is this your business?"
    # Scenario 1
    @scenario = 1
    puts "Single Business Scenario"
    business_name.each{ |word|
      if @browser.text.include? word
        weight += 1
      end
    }
    if weight >= (business_name.length / 2) then
      if @browser.text.include? data['address'] then
        puts "Match Found!"
        businessFound = true
      else
        weight = 0
        data['address'].split(" ").each{ |word|
          address.push(word)
        }
        address.each{ |word|
          if @browser.text.include? word
            weight += 1
          end
        }
        if weight >= (address.length / 2)
          puts "Match Found!"
          businessFound = true
        end
      end
    end
  elsif @browser.text.include? "Is one of these your business?"
    # Scenario 2
    @scenario = 2
    puts "Multiple Businesses Scenario"
    business_name.each{ |word|
      if @browser.text.include? word
        weight += 1
      end
    }
    if weight >= (business_name.length / 2) then
      if @browser.text.include? data['address'] then
        puts "Match Found!"
        businessFound = true
      else
        weight = 0
        data['address'].split(" ").each{ |word|
          address.push(word)
        }
        address.each{ |word|
          if @browser.text.include? word
            weight += 1
          end
        }
        if weight >= (address.length / 2)
          puts "Match Found!"
          businessFound = true
        end
      end
    end
  elsif @browser.text.include? "We could not find"
    # Scenario 3
    @scenario = 3
    puts "No Results Scenario"
  end
  return businessFound
end

def search_business( data )
  
  login (data)

  unless @browser.url =~ /https:\/\/www\.google\.com\/local\/business\/add/
    @browser.goto "https://www.google.com/local/business/add"
  end
  
  if @browser.div(:class => "W0 pBa").exist? && @browser.div(:class => "W0 pBa").visible?
    @browser.div(:class => "W0 pBa").click
  end

  #@browser.div(:text, 'Local Business or Place').when_present.click

  if @browser.text_field(:id => 'Passwd').exist?
    @browser.text_field(:id => 'Passwd').set data['pass'] if @browser.text_field(:id => 'Passwd').exist?
    @browser.button(:value, "Sign in").click
    sleep(3)
  end

  if @browser.element(:css => '.Am').present?
    @browser.element(:css => '.b-U-N').click
    @browser.element(:css => '.bu').click
    @browser.element(:css => '.Am').click
  end
  
  puts "Searching for business..."
  @browser.element(:css => '.b-Ca').when_present.send_keys data['phone']#data['business'] + ", " + data['state'] + ' ' + data['city']
  @browser.img(:src, /search-white/).click
  @browser.element(:css => '.I0vWDf').wait_until_present(60)
  sleep 3 # Just in case some elements haven't loaded yet
rescue => e
  unless @retries == 0
    puts "Error caught in search_business: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in search_business could not be resolved. Error: #{e.inspect}"
  end
end

def handle_scenarios()
  # Handle Result Scenario
  puts "Handling Results Scenario..."
  if @scenario == 1 then
    @browser.h4(:text, "No, this is not my business").click
  elsif @scenario == 2 then
    @browser.h4(:text, "No, these are not my businesses").click
  elsif @scenario == 3 then
    @browser.h4(:text, "I've correctly entered the business and address").click
  else
    raise "Invalid Result Scenario"
  end

  puts "Scenario #{@scenario.to_s} handled."
end

def initial_signup_form( data )
  unless @retries < 3
    @retries = 3
  else
    @browser.refresh
  end
  puts 'Creating business listing'
  # Basic Information, xpath used for reliability
  @browser.element(:css => '.Fd-fb > div:nth-child(2) > label:nth-child(1) > div:nth-child(2) > input:nth-child(1)').when_present.send_keys data['business']
  puts "Business set"
  #Skip Country/Region
  @browser.element(:css => 'div.Xq:nth-child(2) > input:nth-child(2)').send_keys data['address']
  @browser.element(:css => '.OO').send_keys data['city']
  # Set State      
  puts "Selecting State..."
  @browser.element(:css, '.aP > div:nth-child(1)').click
  sleep 1
  @browser.divs(:class, 'c-X').each do |state|
    if state.text == data['state']
      puts "#{state.text} Selected"
      state.click
      break
    end
  end
  @browser.execute_script("
      document.getElementsByTagName('input')[4].disabled=false;
      document.getElementsByTagName('input')[5].disabled=false;
      document.getElementsByTagName('input')[6].disabled=false;
    ")
  sleep 2
  @browser.element(:css => '.cP').send_keys data['zip'].to_s
  puts "Zip set"
  @browser.element(:css => 'input.Cj:nth-child(1)').send_keys data['phone']
  puts "Phone Set"
  data['category'].gsub!(/\d\s?/, "") # Remove numbers
  @browser.element(:css => '.mg').send_keys data['category']
  puts "Category Set"
  @browser.divs(:class, 'Ic-ed').each do |category|
    if category.b.exists?
      cat = category.text + category.b.text
    else
      cat = category.text
    end
    if cat =~ /#{data['category']}/ then
      category.click
    end
  end
  @browser.div(:text, 'Submit').click
  Watir::Wait.until(10) { @browser.url != "https://www.google.com/local/business/add/info" }
rescue => e
  unless @retries == 0
    puts "Error caught in initial_signup_form: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in initial_signup_form could not be resolved. Error: #{e.inspect}"
  end
end

def postcard_verify( data )
  @browser.element(:css => 'div.Id:nth-child(1)').when_present.click
  @browser.element(:css => '.sf8V7e > div:nth-child(3) > input:nth-child(1)').when_present.send_keys data['name']
  @browser.element(:css => '.sf8V7e > div:nth-child(3) > div:nth-child(2) > div:nth-child(1)').click
  
  @browser.element(:css => '.EHnaC').when_present.click #Continue
  sleep 3
  if @browser.element(:css => '.b-P-Tb').present?
    @browser.element(:css => '.b-P-Tb').click
    @browser.element(:css => '.d-Cb-Ba').click
  end
  puts "Page Successfully Created"
rescue
  unless @retries < 3
    @retries = 3
  end
  unless @retries = 0
    @retries -= 1
    retry
  end
end

def add_business_contact( data)
  unless @retries < 3
    @retries = 3
  end
  if @retries < 3
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(3)').when_present.click
  puts "Adding Contact Information..."
  unless data['website'].nil?
    @browser.element(:css => '.vn').when_present.send_keys data['website']
  end
  @browser.element(:css => '.Fv').send_keys data['email']
  if data['mobile?'] == true then
    @browser.element(:css => '.wc').click
    @browser.element(:css => '.Iv').when_present.send_keys data['mobile']
  end
  @browser.element(:css => '.dn').click
  puts "Contact Information Set"

  @browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
  sleep 3 # Saved
rescue => e
  unless @retries == 0
    puts "Error caught in add_business_contact: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_contact could not be resolved. Error: #{e.inspect}"
  end
end

def add_hours( data )
  unless @retries < 3
    @retries = 3
  else
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(5)').when_present.click
  puts "Adding Hours of Operation..."
  7.times { 
    @browser.element(:css => '.Ov > div:nth-child(1)').click 
    sleep 0.5
  }
  data['hours'].each do |day,time|
    day = day.capitalize
    if time.nil? || time == ""
      puts "#{day} is closed"
    elsif time.first.nil? || time.first == ""
      puts "#{day}'s opening time is nil"
    elsif time.last.nil? || time.last == ""
      puts "#{day}'s closing time is nil"
    elsif not time.nil? || time == ""
      puts "Current Day: #{day}"
      if day == "Sunday"
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Sunday').click
        @list.divs(:class, 'c-X c-Ne').first.click
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(2) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      elsif day == "Monday"
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Monday').click
        @list.divs(:class, 'c-X c-Ne')[1].click
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(3) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      elsif day == "Tuesday"
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Tuesday').click
        @list.divs(:class, 'c-X c-Ne')[2].click
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(4) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      elsif day == "Wednesday"
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Wednesday').click
        @list.divs(:class, 'c-X c-Ne')[3].click
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(5) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      elsif day == "Thursday"
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Thursday').click
        @list.divs(:class, 'c-X c-Ne')[4].click
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(6) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      elsif day == "Friday"
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Friday').click
        @list.divs(:class, 'c-X c-Ne')[5].click
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(7) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      elsif day == "Saturday"
        @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > div:nth-child(1)').click
        @list = @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > div:nth-child(2)')
        sleep 0.5
        #@browser.div(:text => 'Saturday').click
        @list.divs(:class, 'c-X c-Ne').last.click
        @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > input:nth-child(3)').send_keys time.first
        @browser.element(:css => 'div.zn:nth-child(8) > div:nth-child(1) > input:nth-child(5)').send_keys time.last
      end
    end
  end
@browser.element(:css => 'div.on:nth-child(3) > div:nth-child(1)').click  
sleep 5
puts "Hours of Operation Set"

@browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
sleep 3 # Saved
rescue => e
  unless @retries == 0
    puts "Error caught in add_hours: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_hours could not be resolved. Error: #{e.inspect}"
  end
end

def add_photos( data )
  unless @retries < 3
    @retries = 3
  else
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(6)').when_present.click
  puts "Adding Business Photos..."
  @browser.element(:css => '.a-kb-vA > div:nth-child(4) > div:nth-child(1)').when_present.click
  if not self.logo.nil?
    sleep 1
    Win.set_upload(self.logo)
    @browser.element(:css => '#picker:ap:2').wait_until_present(120)
  end

  # Additional images
  photos = self.images
  @browser.element(:css => '#picker:ap:2').click
  sleep 1
  if photos.length > 0
    image_index = ""
    for image_index in (0..photos.length-1)
      Win.set_upload()
      @browser.element(:css => '#picker:ap:2').wait_until_present(120)
    end
  end
  @browser.element(:css => '#picker:ap:0').click

  @browser.element(:css => '.b-fy > div:nth-child(1)').wait_until_present # Saving... 
  sleep 3 # Saved

rescue => e
  unless @retries == 0
    puts "Error caught in add_photos: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    puts "Photos could not be added successfully. Skipping..."
    @browser.refresh
    sleep 3
  end
end
end

def add_business_description( data )
  unless @retries < 3
    @retries = 3
  else
    @browser.refresh
  end
  @browser.element(:css => 'div.wb:nth-child(7)').when_present.click
  sleep 3
  @frame = @browser.frame(:id, /bfeSharedRichTextFieldId/)
  @frame.body(:id => /bfeSharedRichTextFieldId/).click
  @frame.body(:id => /bfeSharedRichTextFieldId/).send_keys data['description']
  sleep 2
  @browser.element(:css => 'div.on:nth-child(2) > div:nth-child(1)').click
  puts "Description Set"
rescue => e
  unless @retries == 0
    puts "Error caught in add_business_description: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in add_business_description could not be resolved. Error: #{e.inspect}"
  end
end

def finish_business( data )
  @browser.element(:css => '.rB').when_present.click

  add_business_contact( data )

  add_hours( data )

  # Needs RAutomation support
  #add_photos( data )

  add_business_description( data )

  sleep 3 # Ensure stuff saves

rescue => e
  unless @retries == 0
    puts "Error caught in finish_business: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in finish_business could not be resolved. Error: #{e.inspect}"
  end
end

#Main Steps
@retries = 3
begin
  #login( data ) 
  search_business( data ) # Also logs in, so the rescue can handle it
  if check_scenarios( data ) == true
    self.save_account("Google", {:status => "Pre-existing listing found! Claiming..."})
    if @chained
      self.start("Google/ClaimListing")
    end
  else
    handle_scenarios()
    initial_signup_form( data )
    postcard_verify( data )
    begin
      sleep 5
      if @browser.element(:css => '.rB').present?
        finish_business( data )
      else
        raise InvalidDashboard
      end
    rescue InvalidDashboard
      unless @retries == 0
        puts "Dashboard not found, refreshing page..."
        @browser.refresh
        @retries -= 1
        retry
      else
        raise "Dashboard could not be found!"
      end
    end
    if @chained
      self.start("Google/MailNotify", 10087) # Wait 7 days
    end
    self.save_account("Google", {:status => "Listing created, verify postcard will arrive in 1-2 weeks."})
  end

rescue Timeout::Error
  puts("Caught a TIMEOUT ERROR!")

rescue Selenium::WebDriver::Error::ElementNotVisibleError => e
  puts e.inspect
  puts "Error encountered. Trying to ride it out..."
  #sleep  

end

puts "Payload Completed"
self.success
