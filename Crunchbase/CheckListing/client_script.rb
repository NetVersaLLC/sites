if search_for_business(data)
  self.start("Crunchbase/ClaimListing")
else
  self.start("Crunchbase/CreateListing")
end

true