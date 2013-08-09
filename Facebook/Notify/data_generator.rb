notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=facebook&next_job=PhoneVerify"
notification.title = "Facebook Text Message Verify"
notification.save
