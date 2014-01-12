notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=yahoo&next_job=VerifyMail"
notification.title = "Yahoo Postcard Verify"
notification.save