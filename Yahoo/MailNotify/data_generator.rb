notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=yahoo&next_job=VerifyMail&mail=1"
notification.title = "Yahoo Postcard Verify"
notification.save
