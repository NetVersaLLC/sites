agent = Mechanize.new
agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
agent.user_agent_alias = 'Mac Safari'
page = agent.get("https://www.bingbusinessportal.com/Node:%5BApplication%5D%5C%5CStructure%5C%5CContent%5C%5CLiveLookups%5C%5CAddress%20Book%20Lookup.GetObjectListDataAsJSON?aDataTypeList=Asset%2CBusiness%2CAddress%2CCity%2CStateOrProvince%2CPostalCode%2CPhoneNumber%2CUniqueID%2CCountryOrRegion&aUse=LiveLookup&aCountSubNodes=Y&aSourceFilter=JSON%3A%5B%7B%22DataType%22%3A%22Business%22%2C%22Condition%22%3A%22Equal%20To%22%2C%22Value%22%3A%5B%7B%22Text%22%3A%22#{data['business']}%22%7D%5D%7D%2C%7B%22DataType%22%3A%22Address%22%2C%22Condition%22%3A%22Equal%20To%22%2C%22Value%22%3A%5B%7B%22Text%22%3A%22#{data['zip']}%22%7D%5D%7D%5D&aResultCount=500")
businessFound = [:unlisted]
meta = {}
obj = JSON.parse(page.body)
obj.each do |siness|
  if siness['Business'] =~ /#{data['business']}/
    claimed = RestClient.get "https://www.bingbusinessportal.com/Node:%5BApplication%5D%5C%5CStructure%5C%5CContent%5C%5CLiveLookups%5C%5CLocal%20Businesses.GetObjectListDataAsJSON?aDataTypeList=Ownership%20State&aUse=LiveLookup&aCountSubNodes=Y&aSourceFilter=JSON%3A%5B%7B%22DataType%22%3A%22YPID%22%2C%22Condition%22%3A%22Equal%20To%22%2C%22Value%22%3A%5B%7B%22Text%22%3A%22#{siness['UniqueID']}%22%7D%5D%7D%5D"
    isclaimed = JSON.parse(claimed)
    if isclaimed[0]
      businessFound = [:listed, :claimed]
    else
      businessFound = [:listed, :unclaimed]
    end
    meta['name'] = siness['Business']
    meta['address'] = siness['Address']
    meta['phone'] = siness['PhoneNumber']
    businessFound.push meta
    break
  end
end

[true, businessFound]