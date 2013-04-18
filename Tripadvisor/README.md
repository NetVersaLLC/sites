This payload will search for a business.
If it finds the business it will create and account and attemp to claim it.
If it does not find the business it will go to the Owners section of the site and search for the business
a different way. If it finds the business here it will create an account and claim the business.
If it still doesn't find the business it will request a new listing be created. This can take up to 3 business days
to process. 

The flow is:

find-business yes? -> sign-up -> done & business claimed

find-business no? -> update-existing 
update-existing yes? -> sign-up -> done & business claimed
update-existing no? -> submit_new_common -> done, but no business has been claimed.

If the listing must be requested the payload should be run again at a later date. 

The business type must be Hotel, Restaurant, or Resource
