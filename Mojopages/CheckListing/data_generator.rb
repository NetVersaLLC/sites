data = {}
data[:payload_framework] = PayloadFramework._to_s
phone = business.local_phone.gsub('-','')
data[:phone_area_code] = phone[0..2]
data[:phone_prefix] = phone[3..5]
data[:phone_suffix] = phone[6..9]
data
