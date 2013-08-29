notification = business.notifications.new
notification.url = "/businesses/#{business.id}/codes/new?site_name=adsolutionsyp&next_job=Verify&screen_to_phone=true"
notification.title = "YellowPages Phone Verification"
notification.save