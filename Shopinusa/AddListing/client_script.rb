eval(data['payload_framework'])
class AddListing < PayloadFramework
  def run
    sign_up
    set_business_info
  end

  def verify
    sleep 3
    browser.alert.close if browser.alert.exists?
    verification = browser.text.include? "Congratulations!"
    browser.close
    verification
  end

  def elements
    @elements ||= {}
    @elements[:main] ||= {
      :wrapper => '#ctl00_MainContent_!!!',
      :company_title => 'companyTitle',
      :address => 'streetAddress',
      :city => 'city',
      :state => 'provinceDropDown',
      :zip => 'postalCode',
      :phone => 'localPhoneNum',
      :fax => 'faxNumber',
      :toll_free => 'tollFreeNumber',
      :contact_name => 'contactPerson',
      :email => 'contactEmail',
      :website => 'website',
      :description => 'description',
      :submit => 'subButton',
      :preview => 'skipHyperLink',
      :anti_spam => '/.updateProgress'
    }

    @elements[:captcha] ||= {
      :wrapper => '#recaptcha_!!!',
      :captcha_image => 'challenge_image',
      :captcha_field => 'response_field',
      :captcha_reload => 'reload',
      :verification => '/:contains("Describe your business.")',
      :submit => '/#ctl00_MainContent_subButton'
    }

    @elements[:category_links] ||= {
      :wrapper => "tr td a!!!",
      :category1_link => ":contains('#{data[:categories][0]}')",
      :category2_link => ":contains('#{data[:categories][1]}')"
    }

    @elements[:categories] ||= {
      :parent => :main,
      :wrapper => 'productDataList_ctl0!!!_productTextBox',
      :category1 => '1',
      :category2 => '2',
      :category3 => '3',
      :category4 => '4',
      :category5 => '5'
    }

    @elements[:business_hours] ||= {
      :parent => :main,
      :wrapper => 'customBusinessHours_!!!',
      :members => {
        :mon => 'mon',
        :tues => 'tues',
        :wed => 'wed',
        :thur => 'thur',
        :fri => 'fri',
        :sat => 'sat',
        :sun => 'sun'
        },
      :is_open => '!!!CheckBox',
      :start_hour => 'open!!!HourDropDownList',
      :end_hour => 'close!!!HourDropDownList',
      :start_minute => 'open!!!MinDropDownList',
      :end_minute => 'close!!!MinDropDownList',
      :open_pm => 'open!!!RadioButtonList_0',
      :open_am => 'open!!!RadioButtonList_1',
      :close_pm => 'close!!!RadioButtonList_0',
      :close_am => 'close!!!RadioButtonList_1',
    }

    @elements[:payment_methods] ||= {
      :parent => :main,
      :wrapper => 'ctlPayment_paymentCheckBoxList_!!!',
      :cash => '5',
      :checks => '4',
      :visa => '0',
      :mastercard => '1',
      :amex => '2',
      :discover => '7',
      :diners => '8'
    }
    @elements
  end

  def sign_up
    browser.goto 'http://www.shopinusa.com/signup/'
    enter :company_title
    enter :address
    enter :city
    wait_until_present(:state)
    select :state
    enter :zip
    enter :phone 
    enter :fax
    enter :toll_free
    enter :contact_name
    enter :email 
    enter :website
    context(:category_links) do
      click :category1_link
      context(:main) { wait_while_present(:anti_spam) }
      wait_until_present(:category2_link)
      click :category2_link
    end
    context(:captcha) do 
      solve do
        context(:main) { submit }
        context(:main) { wait_while_present(:anti_spam) }
        sleep 2
        browser.text.include? 'Describe your business.'
      end
    end
  end

  def set_business_hours
    context(:business_hours) do
      data[:days_open].each do |day|
        check :"#{day}:is_open"
        context(:main) { wait_while_present(:anti_spam) }
        context_member(day,day.to_s.capitalize)
        context_member(day,"Thurs") if day.to_s == "thur"
        select :"#{day}:start_hour"
        select :"#{day}:start_minute"
        select :"#{day}:end_hour"
        select :"#{day}:end_minute"
        context_member(day,"Thur") if day.to_s == "thur"
        [:open_am, :open_pm, :close_am, :close_pm].each do |radio|
          radio = [day,radio].join(":").to_sym
          click radio if data[radio]
        end
      end
      data[:days_closed].each do |day|
        uncheck :"#{day}:is_open"
        context(:main) {wait_while_present(:anti_spam)}
      end
    end
  end

  def set_business_info
    context(:main) do
      enter :description
      set_business_hours
      context(:categories) do
        data[:categories].each_with_index do |category,n|
          @data[:"category#{n+1}"] = category
          enter :"category#{n+1}"
        end
      end
      context(:payment_methods) do
        data[:payment_methods].each do |payment_method|
          check :"#{payment_method}"
        end
      end
      wait_while_present(:anti_spam)
      submit
      wait_until_present(:preview)
      click :preview
    end
  end
end

AddListing.new(data).verify