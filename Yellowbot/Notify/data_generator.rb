notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=Yellowbot&next_job=ClaimListing"
notification.title = "Yellowbot Phone Verify"
notification.save
