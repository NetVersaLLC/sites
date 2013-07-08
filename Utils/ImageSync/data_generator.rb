data = {}
images = []
data['images'] = images
business.images.each do |image|
  if image.is_logo == true
    data['logo'] = image.url()
  end
  images.push image.url()
end
data
