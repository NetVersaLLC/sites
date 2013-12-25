notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=yelp&next_job=ClaimListing"
notification.title = "Yelp Phone Verify"
notification.save