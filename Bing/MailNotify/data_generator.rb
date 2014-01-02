notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=bing&next_job=VerifyMail"
notification.title = "Bing Postcard Verify"
notification.save