notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=yahoo&next_job=SignUp"
notification.title = "Yahoo Phone Verify"
notification.save
