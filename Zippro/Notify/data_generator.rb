notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=zippro"
notification.save
