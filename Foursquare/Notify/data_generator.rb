notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=foursquare&next_job=ClaimListing"
notification.save
