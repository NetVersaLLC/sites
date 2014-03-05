notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=bing&next_job=VerifyMail&mail=1"
notification.title = "Bing Postcard Verify"
notification.save
