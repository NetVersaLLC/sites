#Image upload code, temporary
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
  #           _In_      int nIDDlgItem
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
  #       _In_      UINT Msg,
  #       _In_      WPARAM wParam,
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
#End of image upload code



# Developer's Notes
# Twitter seems to suspend accounts
# it deems are fake. Potential remedy
# is to simulate standard user interaction,
# such a following other users and some initial
# tweets.


# Browser Code
@browser = Watir::Browser.new :firefox
at_exit do
    unless @browser.nil?
        @browser.close
    end
end

# Methods
def solve_captcha
  image = "#{ENV['USERPROFILE']}\\citation\\twitter_captcha.png"
  obj = @browser.image( :src, /recaptcha/ )
  puts "CAPTCHA source: #{obj.src}"
  puts "CAPTCHA width: #{obj.width}"
  obj.save image

  CAPTCHA.solve image, :manual
end


def enter_captcha
    capSolved = false
    count = 1
    until capSolved or count > 5 do
        captcha_code = solve_captcha
        @browser.text_field( :id, "recaptcha_response_field" ).set captcha_code
        @browser.button( :name, "submit_button").click

        if @browser.p(:text, "Creating your account…").exists?
          @browser.p(:text, "Creating your account…").wait_while_present
        else
          sleep 10 # Got a better solution?
        end
        
        if not @browser.img(:id, 'recaptcha_challenge_image').present?
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

def signup_success
    # Are we on the right page?
    Watir::Wait.until { @browser.url.include? /twitter\.com/ }
    page = Nokogiri::HTML(open(@browser.url))
    # Return true when if condition is met
    if page.text.scan("Welcome, #{data['username']}")
        return true
    elsif @browser.url.include? /twitter\.com\/welcome\/intro/
        return true
    elsif page.text.scan("The Twitter Teacher")
        return true
    elsif page.css('faux-tweet')
        return true
    else
        return false
    end
end

def create_account(data)
    retries ||= 3
    @browser.goto("https://twitter.com/signup")
    if @browser.text.include? "You are already logged in. Log out and try again."
      puts "Already logged in."
      return true
    end
    @browser.text_field(:name => 'user[name]').when_present.set data['fullname']
    @browser.text_field(:name => 'user[email]').set data['email']
    @browser.text_field(:name => 'user[user_password]').set data['password']
    until @browser.text.include? "Username is available."
        seed = rand(1000).to_s
        data['username'] = data['username'][0 .. 10] + seed
        @browser.text_field(:name => 'user[screen_name]').set data['username']
        @browser.text_field(:name => 'user[screen_name]').send_keys :tab
        puts "Waiting on validating..."
        @browser.p(:text => 'Validating...').wait_while_present
        sleep 2
    end
    @browser.checkbox(:name => 'user[remember_me_on_signup]').clear
    @browser.checkbox(:name => 'user[use_cookie_personalization]').clear
    puts "Waiting on JS validation..."
    sleep 10 # allow javascript validation to finish
    @browser.button(:value => 'Create my account').click
    sleep 3 # Check for captcha
    if @browser.img(:id, 'recaptcha_challenge_image').present?
      enter_captcha
    end
    sleep 3
    if @browser.p(:text, "Creating your account…").exists?
      @browser.p(:text, "Creating your account…").wait_while_present
    else
      sleep 5
    end
    unless signup_success == true
        raise "signup_success returned false."
    end
rescue => e
    retry unless (retries -= 1).zero?
    self.failure(e)
else
    puts "Account created."
end

def follow_other_tweeters(data)
    retries ||= 3
    @browser.goto("https://twitter.com/welcome/recommendations")
    @browser.element(:css, '.js-who-to-follow-search > div:nth-child(1) > input:nth-child(2)').when_present.send_keys data['topic'] #category1
    @browser.element(:css, '.js-who-to-follow-search > div:nth-child(1) > input:nth-child(2)').send_keys :enter
    @browser.div(:class, 'pushstate-spinner').wait_while_present
    if @browser.text.include? "No people results for"
        @browser.goto('https://twitter.com/welcome/recommendations')
        Watir::Wait.until { @browser.div(:class, 'faux-tweet').exists? }
    end
    until @browser.text.include? "Great!"
        tweeters = @browser.spans(:text, /Follow/)
        tweeters[0..5].each do |button|
            sleep rand(3)
            button.click
        end
        sleep 1
    end
rescue => e
    retry unless (retries -= 1).zero?
    self.failure(e)
else
    puts "Tweeters followed."
end

def bypass_interests(data)
    retries ||= 3
    @browser.goto("https://twitter.com/welcome/interests")
    @browser.element(:css, '.js-who-to-follow-search > div:nth-child(1) > input:nth-child(2)').when_present.send_keys data['topic'] #category1
    @browser.element(:css, '.js-who-to-follow-search > div:nth-child(1) > input:nth-child(2)').send_keys :enter
    @browser.div(:class, 'pushstate-spinner').wait_while_present
    if @browser.text.include? "No people results for"
        @browser.goto('https://twitter.com/welcome/interests/twitter')
        Watir::Wait.until { @browser.div(:class, 'faux-tweet').exists? }
    end
    until @browser.text.include? "Great!"
        tweeters = @browser.spans(:text, /Following/)
        unless tweeters.length < 5
            tweeters[0..5].each do |button|
                button.click
                sleep 1 # Required
                button.click
                sleep rand(3)
            end
            sleep 1
        else
            tweeters = @browser.spans(:text, /Follow/)
            tweeters[0..5].each do |button|
                sleep rand(3)
                button.click
            end
            sleep 1
        end
    end
rescue => e
    retry unless (retries -= 1).zero?
    self.failure(e)
else
    puts "Interests bypassed."
end

def setup_profile_basics(data)
    retries ||= 3
    @browser.goto("https://twitter.com/welcome/profile")
    @browser.textarea(:id, 'welcomeProfileBio').when_present.set data['bio']
    # Image upload, to do
    #@browser.div(:class, 'image-selector').click
    #Win.set_upload("C:\\Users\\Work\\Desktop\\Jellyfish.jpg")
    #Watir::Wait.until { @browser.img(:src, /data\:image/).exists? }
    @browser.link(:text, 'Done').when_present.click
rescue => e
    retry unless (retries -= 1).zero?
    self.failure(e)
else
    puts "Profile basics setup."
end

# Controller
create_account(data)
follow_other_tweeters(data)
bypass_interests(data)
setup_profile_basics(data)
if @browser.text.include? "Confirm your email address to access all of Twitter's features"
    self.success
else
    self.success("Account created, but landed on a different page.")
end
