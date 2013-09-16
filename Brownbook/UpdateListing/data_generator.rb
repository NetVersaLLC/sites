notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=ibegin&next_job=Verify"
notification.title = "Ibegin Phone Verify"
notification.save