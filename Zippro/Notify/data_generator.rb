notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=zippro&next_job=VerifyPhone"
notification.title = "Zippro Phone Verify"
notification.save
