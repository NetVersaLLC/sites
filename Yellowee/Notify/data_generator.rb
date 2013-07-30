notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=yellowee&next_job=AddListing"
notification.title = "Yellowee Phone Verification"
notification.save
