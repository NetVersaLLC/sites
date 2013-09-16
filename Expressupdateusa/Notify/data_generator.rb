notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=expressupdateusa&next_job=ClaimListing&screen_to_phone=true"
notification.title = "Expressupdate Claim Listing Verify"
notification.save