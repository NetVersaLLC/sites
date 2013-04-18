#Select payment opttion
def card_type(payment)
  @card_type = ""  
  case 
    when payment == 'American Express'
      @card_type = 3
    when payment == 'Debit Cards'
      @card_type = 5
    when payment == 'Google Checkout'
      @card_type = 10
    when payment == 'PayPal'
      @card_type = 9
    when payment == 'Cash Only'
      @card_type = 11
    when payment == 'Diner\'s Club'
      @card_type = 8
    when payment == 'MasterCard'
      @card_type = 2
    when payment == 'Visa'
      @card_type = 1
    when payment == 'Checks'
      @card_type = 6
    when payment == 'Discover'
      @card_type = 4
    end
    return @card_type
end

def search_by_phone(data)
  @business_found = false
  @browser.text_field(:name => 'phone').set data[ 'phone' ]
  @browser.button(:value=> 'Search').click
  if not @browser.html.include?("<i>No matches found for <b>")
    @business_found = true
  end
  return @business_found
end

#Claim business
def claim_business(data)
  if @browser.link(:text=> 'Claim This Business').exist?
    @browser.link(:text=> 'Claim This Business').click
    add_new_business(data)
  else
    puts "Business is already claimed"
  end
end


def sign_in(data)
  @browser.goto("http://www.magicyellow.com/login.cfm")
  @browser.text_field(:id => 'login').set data['email']
  @browser.text_field(:name => 'password').set data['password']
  @browser.button(:value => 'Submit').click

end