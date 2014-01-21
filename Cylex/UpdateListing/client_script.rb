# Developer Notes
# update_contacts fails when trying to click a button to
# delete existing contacts. Commented out for now.
# Hours of Operation also fails to make any changes.
# Commented out for now.

# Agent Settings
agent = Mechanize.new{ |agent|
  agent.user_agent_alias = 'Windows Mozilla'
  ca_path = "ca-bundle.crt"
  agent.ca_file = ca_path
}

# Methods
def login(data, agent)
  page = agent.get("https://admin.cylex-usa.com/firma_signin.aspx?fir_nr=&d=cylex-usa.com")
  form = page.form_with("aspnetForm")
  form.field_with(:name => /firma_id/).value = data['email']
  form.field_with(:name => /companypass1/).value = data['password']
  page = form.click_button()
  if not page.body.include?('Profile complete')
    raise "Login failed."
  end
  puts "Logged in."
rescue => e
  unless @retries == 0
    puts "Error caught in login: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in login could not be resolved. Error: #{e.inspect}"
  end
end

def update_basic_information(data, agent)
  page = agent.get("https://admin.cylex-usa.com/firma_page.aspx?action=companycontact&d=cylex-usa.com")
  form = page.form_with("aspnetForm")
  form.field_with(:name => /companyname/).value = data['business']
  form.field_with(:name => /companystreet/).value = data['address'] + ', ' + data['address2']
  form.field_with(:name => /companycity/).value = data['city']
  form.field_with(:name => /postnr/).value = data['zip']
  form.field_with(:name => /tb_region/).value = data['state']
  form.field_with(:name => /companyweb/).value = data['website']
  #page.link_with(:id => /GenerateNapshotImg/).click
  form.field_with(:name => /companymail/).value = data['email']
  form.field_with(:id => /p_scnt_phone/).value = data['phone']
  form.field_with(:id => /p_scnt_fax/).value = data['fax']
  page = form.click_button(form.button_with(:type => 'submit'))
  if not page.body.include?('Saving was successful.')
    raise "[Basic] Update failed."
  end
  puts "[Basic] Updated successful."
rescue => e
  unless @retries == 0
    puts "Error caught in update_basic_information: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_basic_information could not be resolved. Error: #{e.inspect}"
  end
end

def update_detailed_information(data, agent)
  page = agent.get("https://admin.cylex-usa.com/firma_page.aspx?action=companydetail&d=cylex-usa.com")
  form = page.form_with("aspnetForm")
  form.field_with(:name => /tb_keywords/).value = data['keywords']
  form.field_with(:name => /tb_shortdesc/).value = data['description']
  form.field_with(:name => /tb_serviceareas/).value = data['city']
  page = form.click_button(form.button_with(:type => 'submit'))
  if not page.body.include?('Saving was successful.')
    raise "[Detail] Update failed."
  end
  puts "[Detail] Updated successful."
rescue => e
  unless @retries == 0
    puts "Error caught in update_detailed_information: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_detailed_information could not be resolved. Error: #{e.inspect}"
  end
end

def update_contacts(data, agent)
  page = agent.get("https://admin.cylex-usa.com/firma_page.aspx?action=contacts&d=cylex-usa.com")
  agent.click(page.link_with(:id => /deleteContactBtn/))
  form = page.form_with("aspnetForm")
  form.field_with(:name => /ddldept/).value = 11 # Management
  if data['gender'] == "Female"
    form.field_with(:name => /ddltitle/).value = 2 # Ms.
  else
    form.field_with(:name => /ddltitle/).value = 1 # Mr.
  end
  form.field_with(:name => /vorname/).value = data['first_name']
  form.field_with("ctl00$ContentPlaceHolder1$contactpersons$name").value = data['last_name']
  form.field_with(:name => /phone/).value = data['phone']
  form.field_with(:name => /fax/).value = data['fax']
  form.field_with(:name => /mobile/).value = data['mobile']
  form.field_with(:name => /email/).value = data['email']
  page = form.click_button(form.button_with(:type => 'submit'))
  if not page.body.include?('The saving was successful.')
    raise "[Contacts] Update failed."
  end
  puts "[Contacts] Updated successful."
rescue => e
  unless @retries == 0
    puts "Error caught in update_contacts: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_contacts could not be resolved. Error: #{e.inspect}"
  end
end

def update_payment_methods(data, agent)
  page = agent.get("https://admin.cylex-usa.com/firma_page.aspx?action=paymentmethods&d=cylex-usa.com")
  form = page.form_with("aspnetForm")
  data[ 'payments' ].each{ |pay|
    form.checkbox_with(pay).checked = true
  }
  page = form.click_button(form.button_with(:type => 'submit'))
  if not page.body.include?('The saving was successful')
    raise "[Payment Methods] Update failed."
  end
  puts "[Payment Methods] Updated successful."
rescue => e
  unless @retries == 0
    puts "Error caught in update_payment_methods: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_payment_methods could not be resolved. Error: #{e.inspect}"
  end
end

def update_hours_of_operation(data, agent)
  page = agent.get("https://admin.cylex-usa.com/firma_page.aspx?action=openinghours&d=cylex-usa.com")
  form = page.form_with("aspnetForm")
  if data['24hours'] == true
    # Don't ask, it only works this way
    form.checkboxes.each do |checkbox|
      if checkbox.name =~ /CheckBoxNonStop/
        checkbox.check
        break
      end
    end
  else
    data['hours'].each do |day,time|
      unless data['hours'][day].nil?
        if day == 'monday'
          count = 1
        elsif day == 'tuesday'
          count = 2
        elsif day == 'wednesday'
          count = 3
        elsif day == 'thursday'
          count = 4
        elsif day == 'friday'
          count = 5
        elsif day == 'saturday'
          count = 6
        elsif day == 'sunday'
          count = 7
        end
        puts "Day: #{count.to_s}"
        # Don't ask, it only works this way
        form.checkboxes.each do |checkbox| 
          if checkbox.name =~ /ctl0#{count}$CheckBox/
            if checkbox.checked == true
              checkbox.checked = false
            end
          end
        end
        # I don't know why it only works this way, I tried the other ways
        form.fields.each do |field|
          if field.name =~ /ctl0#{count}$DropDownListCurrentDayHour/
            puts "Day: #{day}, Hour: #{time.first[0..1].to_s}"
            field.value = time.first[0..1].to_s
          end
          if field.name =~ /ctl0#{count}$DropDownListCurrentDayMinutes/
            puts "Day: #{day}, Minutes: #{time.first[3..4].to_s}"
            field.value = time.first[3..4].to_s
          end
          if field.name =~ /ctl0#{count}$DropDownList12h_1/
            puts "Day: #{day}, AM/PM: #{time.first[5..6].to_s}"
            field.value = time.first[5..6].to_s
          end
          if field.name =~ /ctl0#{count}$DropDownListCurrentDayHour2/
            field.value = time.last[0..1].to_s
          end
          if field.name =~ /ctl0#{count}$DropDownListCurrentDayMinutes2/
            field.value = time.last[3..4].to_s
          end
          if field.name =~ /ctl0#{count}$DropDownList12h_2/
            field.value = time.last[5..6].to_s
          end
        end
      else
      # Don't ask, it only works this way
      puts "#{day} closed."
        form.checkboxes.each do |checkbox|
          if checkbox.name =~ /ctl0#{count}$CheckBox/
            checkbox.check
            break
          end
        end
      end
    end
  end
  page = form.click_button(form.button_with(:type => 'submit'))
  if not page.body.include?('The saving was successful.')
    raise "[Hours] Update failed."
  end
  puts "[Hours] Updated successful."
rescue => e
  unless @retries == 0
    puts "Error caught in update_hours_of_operation: #{e.inspect}"
    puts "Retrying in two seconds. #{@retries} attempts remaining."
    sleep 2
    @retries -= 1
    retry
  else
    raise "Error in update_hours_of_operation could not be resolved. Error: #{e.inspect}"
  end
end

# Main Controller
@retries = 3 # Global number of retries
login(data, agent) # Logs the client into their dashboard
update_basic_information(data, agent) # Updates: Business name, address, city, zip, state, website, email, phone, and fax
update_detailed_information(data, agent) # Updates: Keywords, description, service area
#update_contacts(data, agent) # Updates: Client Contact information for potential customers
update_payment_methods(data, agent) # Updates: Business payment methods
#update_hours_of_operation(data, agent) # Updates: Hours of Operation
self.save_account("Cylex", {:status => "Listing updated successfully!"}) # Updates Cylex status
self.success # Returns "Job completed successfully."
