images = data['images']
i = 0

root_dir = "#{ENV['USERPROFILE']}\\citation\\#{$bid}"
directory_name = "#{root_dir}\\images"
Dir.mkdir(directory_name) unless File.exists?(directory_name)

Dir.open(directory_name).each do |file|
  next if file =~ /^\./
  FileUtils.rm "#{directory_name}\\#{file}"
end

logo = self.logo
if logo != nil and File.exists? logo
  FileUtils.rm logo
end

images.each do |image|
  i = i + 1
  if image =~ /\.(png|jpe?g)/i
    src = RestClient.get(image)
    File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\images\\image#{i}.#{$1}", "wb").write src
  end
end
if data['logo'] != nil and  data['logo'] =~ /\.(png|jpe?g)/i
  src = RestClient.get(data['logo'])
  File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\logo.#{$1}", "wb").write src
end

true
