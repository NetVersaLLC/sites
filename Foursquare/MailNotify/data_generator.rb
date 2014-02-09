notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=foursquare&next_job=VerifyMail"
notification.title = "Foursquare Postcard Verify"
notification.save