puts "data: #{data.inspect}"
images = data['images']
i = 0

puts "0"
root_dir = "#{ENV['USERPROFILE']}\\citation\\#{$bid}"
puts "1"
directory_name = "#{root_dir}\\images"
puts "2"
Dir.mkdir(directory_name) unless File.exists?(directory_name)
puts "3"

Dir.open(directory_name).each do |file|
  puts "4"
  next if file =~ /^\./
  FileUtils.rm "#{directory_name}\\#{file}"
end

puts "5"
logo = self.logo
puts "Logo: #{logo}"
if logo != nil and File.exists? logo
  puts "6"
  FileUtils.rm logo
end

puts "7"
images.each do |image|
  i = i + 1
  if image =~ /\.(png|jpe?g)/i
    puts "8"
    src = RestClient.get(image)
    File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\images\\image#{i}.#{$1}", "wb").write src
  end
end
puts "9"
if data['logo'] != nil and  data['logo'] =~ /\.(png|jpe?g)/i
  puts "10"
  src = RestClient.get(data['logo'])
  File.open("#{ENV['USERPROFILE']}\\citation\\#{$bid}\\logo.#{$1}", "wb").write src
end
puts "11"

true
