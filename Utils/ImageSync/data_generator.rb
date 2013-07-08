data = {}

data['images'] = business.images
business.images.each do |image|
  if image.is_logo == true
    data['logo'] = image.url()
  end
end


data