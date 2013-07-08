images = data['images']
images.each do |image|
  src = RestClient.get(image['url'])
  File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\images\\#{image}", "wb").write src
end
if data['logo'] != nil and  data['logo'] =~ /\.(?:png|jpe?g)$/
  src = RestClient.get(data['logo'])
  File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\logo.#{$1}", "wb").write src
end
