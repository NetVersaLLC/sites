notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=google&next_job=MailVerify"
notification.title = "Google Postcard Verify"
notification.save