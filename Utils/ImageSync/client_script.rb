images = data['images']
images.each do |image|
  src = RestClient.get(image['url'])
  File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\images\\#{image}", "wb").write src
end
