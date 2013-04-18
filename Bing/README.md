# Bing

## New Sign Up

A new user gets the job SignUp, this job then creates a Hotmail account
and stores it in business.bings via the Bing controller's save_hotmail
method. This job chains in the CheckListing job which checks if the
listing is already on Bing or not.

If it is then ClaimListing is chained in. If not then CreateListing is
called. Either of these will chain Update afterward.

