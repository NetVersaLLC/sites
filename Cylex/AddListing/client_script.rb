agent = Mechanize.new
agent.user_agent_alias = 'Windows Mozilla'

def solve_captcha(page)
    captcha = page.image_with(:src => /randomimage/)
    captcha.fetch.save! "#{ENV['USERPROFILE']}\\citation\\cylex_captcha.png"
    image = "#{ENV['USERPROFILE']}\\citation\\cylex_captcha.png" # Do not combine with above line
    captcha_text = CAPTCHA.solve image, :manual
    return captcha_text
end

def enter_captcha(page)
    capSolved = false
    capRetries = 5
    until capSolved == true # A
        form = page.form_with("aspnetForm")
        form.field_with(:name => /captchaTb/).value = solve_captcha(page)
        page = form.click_button(form.button_with(:type => 'submit'))
        if page.body =~ /Thank you for updating this presentation page!/
            capSolved = true
            puts "[Listing] Updated successfully."
        elsif page.body =~ /Business information/ # Add Business
            capSolved = true
        elsif capRetries == 0 # B
            throw "Payload did not complete successfully due to captcha."
        else
            capRetries -= 1
        end
    end
    return page
end

def update_business(data, page)
    form = page.form_with("aspnetForm")
    form.field_with(:name => /companystreet/).value = data['address'] + ", " + data['address2']
    form.field_with(:name => /companycity/).value = data['city']
    form.field_with(:name => /postnr/).value = data['zip']
    form.field_with(:name => /tb_region/).value = data['state']
    form.field_with(:name => /companyphone/).value = data['phone']
    form.field_with(:name => /companyfax/).value = data['fax']
    form.field_with(:name => /companyweb/).value = data['website']
    form.field_with(:name => /companymail/).value = data['email']
    # Begin update of Hours of Operation
    form.radiobutton_with(:value => '2').check
    #pp page
    if data['24hours'] == true
        # Don't ask, it only works this way
        form.checkboxes.each do |checkbox|
            if checkbox.name =~ /CheckBoxNonStop/
                checkbox.check
                break
            end
        end
    else
        count = 0
        data['hours'].each do |day,time|
            count += 1
            unless data['hours'][day].nil?
                # Don't ask, it only works this way
                form.checkboxes.each do |checkbox| 
                    if checkbox.name =~ /ctl0#{count}$CheckBox/
                        checkbox.uncheck
                        break
                    end
                end
                # I don't know why it only works this way, I tried the other ways
                form.fields.each do |field|
                    if field.name =~ /ctl0#{count}$DropDownListCurrentDayHour/
                        field.value = time.first[0..1].to_s
                    end
                    if field.name =~ /ctl0#{count}$DropDownListCurrentDayMinutes/
                        field.value = time.first[3..4].to_s
                    end
                    if field.name =~ /ctl0#{count}$DropDownList12h_1/
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
                form.checkboxes.each do |checkbox|
                    if checkbox.name =~ /ctl0#{count}$CheckBox/
                        checkbox.check
                        break
                    end
                end
            end
        end
    end
    # End update of Hours of Operation
    form.field_with(:name => /tb_keywords/).value = data['keywords']
    form.field_with(:name => /shortdesc/).value = data['description']
    form.field_with(:name => /tb_complain/).value = data['update_reason']
    form.field_with(:name => /visitor_firstname/).value = data['first_name']
    form.field_with(:name => /visitor_surname/).value = data['last_name']
    form.field_with(:name => /visitor_email/).value = data['email']
    enter_captcha(page)
    @update = true
end

page = agent.get("http://admin.cylex-usa.com/firma_default.aspx?step=0&d=cylex-usa.com")
form = page.form_with("aspnetForm")
form.field_with(:name => /companyname/).value = "testgarble"#data['business']
form.field_with(:name => /city/).value = ''#data['city']
form.field_with(:name => /website/).value = ''#data['website']
page = form.click_button()
@update = false
page.links.each do |link|
    if link.href =~ /#{data['search_business']}/
        puts "Updating!"
        page = agent.click(link)
        update_business(data, page)
        break
    end
end
# This only runs if the business isn't updating
if @update == false then
    page = agent.click(page.link_with(:text => "Add Company"))
    form = page.form_with("aspnetForm")
    form.field_with(:name => /companyname/).value = data['business']
    form.field_with(:name => /companypass1/).value = data['password']
    form.field_with(:name => /companypass2/).value = data['password']
    form.field_with(:name => /companystreet/).value = data['address'] + ', ' + data['address2']
    form.field_with(:name => /companycity/).value = data['city']
    form.field_with(:name => /postnr/).value = data['zip']
    form.field_with(:name => /companyweb/).value = data['website']
    form.field_with(:name => /companymail/).value = data['email']
    form.field_with(:name => /companyphone/).value = data['phone']
    form.field_with(:name => /companyfax/).value = data['fax']
    form.checkbox_with(:name => /cbaccept/).check
    page = enter_captcha(page)
    form = page.form_with("aspnetForm")
    form.field_with(:name => /tb_keywords/).value = data['keywords']
    form.field_with(:name => /tb_shortdesc/).value = data['description']
    page = form.click_button(form.button_with(:name => /b_save/))
    if page.body =~ /Logged as/
        puts "[Listing] Added successfully."
    else
        throw "Listing did not add successfully."
    end
    # Update Service Area
    page = page.link_with(:href => /serviceAreas/).click
    form = page.form_with("aspnetForm")
    form.field_with(:name => /tb_serviceareas/).value = data['city']
    page = form.click_button(form.button_with(:type => 'submit'))
    if page.body =~ /Saving was successful/
        puts "[Service Area] Updated successfully."
    else
        puts "[Service Area] Something went wrong, continuing anyway."
    end
    page = page.link_with(:id => /btn_home/).click
    # Update Contact persons
    page = page.link_with(:href => /action=contacts/).click
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
    if page.body =~ /The saving was successful/
        puts "[Contacts] Updated successfully."
    else
        puts "[Contacts] Something went wrong, continuing anyway."
    end
    page = page.link_with(:id => /btn_home/).click
    # Update payment methods
    page = page.link_with(:href => /action=paymentmethods/).click
    form = page.form_with("aspnetForm")
    data[ 'payments' ].each{ |pay|
      form.checkbox_with(pay).checked = true
    }
    page = form.click_button(form.button_with(:type => 'submit'))
    if page.body =~ /The saving was successful/
        puts "[Payment Methods] Updated successfully."
    else
        puts "[Payment Methods] Something went wrong, continuing anyway."
    end
=begin
    page = page.link_with(:id => /btn_home/).click
    # Update company logo
    unless self.logo.nil? || self.logo == ""
        begin
            page = page.link_with(:href => /action=companylogo/).click
            form = page.form_with("aspnetForm")
            form.file_upload_with(:name => /FileUpload1/).file_name = self.logo
            sleep 20 # File takes time to upload, couldn't verify upload
            page = form.click_button(form.button_with(:name => /ButtonSaveChanges/))
            sleep 10 # Couldn't verify that the image saved correctly
            page = page.link_with(:id => /btn_home/).click
            puts "[Logo] Appears to have updated successfully."
        rescue
            page = page.link_with(:id => /btn_home/).click
            logo_error = true
            throw "[Logo] Something went wrong, continuing anyway."
        end
    end
    if not logo_error.nil? || logo_error == true
        catch "[Logo] Something went wrong, continuing anyway."
    end
    # Update company gallery
    unless self.images.nil? || self.images == ""
        page = page.link_with(:href => /action=companygallery/).click
        form = page.form_with("aspnetForm")
        self.images.each do |image|
            count = 0
            count += 1
            form.field_with(:name => /tb_title/).value = count.to_s
            form.file_upload_with(:name => /FileUpload1/).file_name = image
            page = form.click_button(form.button_with(:name => /Upload_Image/))
            sleep 20 
            if page.body =~ /Saving was successful./
                puts "[Images] Image #{count} uploaded successfully."
            else
                page = page.link_with(:id => /btn_home/).click
                images_error = true
                throw "[Images] Image #{count} did not upload successfully."
            end
        end
    end
    if not images_error.nil? || images_error == true
        catch "[Images] Image #{count} did not upload successfully."
    end
=end
    # TODO - There's a few unsupported features on this site
end
true