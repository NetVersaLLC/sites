notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=google&next_job=notify"
notification.title = "Google Account SignUp"
notification.save
