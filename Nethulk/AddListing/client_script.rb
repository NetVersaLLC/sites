response = RestClient.post( "http://www.nethulk.com/business_sign_up.php",
    :m_name_bus => data['business'],
    :m_email_bus => data['email'],
    :m_phone_bus => data['local_phone'],
    :m_fax_bus => data['fax'],
    :m_addr_bus => data['address'],
    :m_city_bus => data['city'],
    :m_state_bus => data['state'],
    :m_zip_bus => data['zip'],
    :m_url => data['website'],
    :m_desc => data['description'],
    :m_name => data['contact_name'],
    :m_email => data['email'],
    :m_phone => data['mobile_phone'],
    :m_addr => data['address'],
    :m_city => data['city'],
    :m_state => data['state'],
    :m_zip => data['zip'],
    :cc_fname => '',
    :cc_lname => '',
    :cc_email => '',
    :cc_num => '',
    :cc_cid => '',
    :cc_exp => '',
    :x_type => 0,
    :submitme => 1
    )

if response.to_s.include? "Business Update Successful"
    true
else
    raise "Payload did not submit"
end