images = data['images']
i = 0
images.each do |image|
  i = i + 1
  if image =~ /\.(png|jpe?g)/i
    src = RestClient.get(image)
    File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\images\\image#{i}.#{$1}", "wb").write src
  end
end
if data['logo'] != nil and  data['logo'] =~ /\.(?:png|jpe?g)$/
  src = RestClient.get(data['logo'])
  File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\logo.#{$1}", "wb").write src
end

true
