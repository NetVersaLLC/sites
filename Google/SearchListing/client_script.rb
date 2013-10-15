api_key = 'AIzaSyCBULo3dEbDt8B1rIG4bKgzkUNx5_ubgs4'

latlon = "#{data['latitude']},#{data['longitude']}"

#replace & with and
def replace_and(business)
  return business.gsub("&","and")
end

url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{latlon}&radius=50000&keyword=#{CGI.escape(data['business'])}&sensor=false&key=#{api_key}"

res = RestClient.get url
results = JSON.parse(res)

businessFound = {
  :status => :unlisted
}

if results['results'] and results['results'].length > 0
  results['results'].each do |result|
    if replace_and(result['name']) =~ /#{replace_and(data['business'])}/i
      businessFound = {
	:status => :listed
      }
      res = RestClient.get "https://maps.googleapis.com/maps/api/place/details/json?reference=#{result['reference']}&sensor=true&key=#{api_key}"
      place = JSON.parse( res )
      businessFound['listed_name']  = result['name'] # Return business name given on webpage
      businessFound['listed_phone'] = place['result']['formatted_phone_number']
      businessFound['listed_address'] = place['result']['formatted_address']
      businessFound['listed_url'] = place['result']['url']
      break
    end
  end
end

[true, businessFound]
