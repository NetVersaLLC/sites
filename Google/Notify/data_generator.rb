notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=google&next_job=ClaimVerify"
notification.title = "Google Claim Verify"
notification.save
