notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=localeze&next_job=SignUp"
notification.save
