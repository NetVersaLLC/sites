api_key = 'AIzaSyCBULo3dEbDt8B1rIG4bKgzkUNx5_ubgs4'

latlon = "#{data['latitude']},#{data['longitude']}"
formatted_business = data['business'].gsub('&', 'and')

url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{latlon}&radius=50000&keyword=#{CGI.escape(data['business'])}&sensor=false&key=#{api_key}"

res = RestClient.get  url
results = JSON.parse(res)

businessFound = {
  :status => :unlisted
}

if results['results'] and results['results'].length > 0
  results['results'].each do |result|
  formatted_business_res =   result['name'].gsub('&', 'and')

    if formatted_business_res =~ /#{formatted_business}/i 
      businessFound = {
	:status => :listed
      }
      res = RestClient.get "https://maps.googleapis.com/maps/api/place/details/json?reference=#{result['reference']}&sensor=true&key=#{api_key}"
      place = JSON.parse( res )
      businessFound['listed_phone'] = place['result']['formatted_phone_number']
      businessFound['listed_address'] = place['result']['formatted_address']
      businessFound['listed_url'] = place['result']['url']
      break
    end
  end
end

[true, businessFound]
