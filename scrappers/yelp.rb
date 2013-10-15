require 'awesome_print'

class Yelp < AbstractScrapper
  # http://www.yelp.com/search?find_desc=Inkling+Tattoo+Gallery&find_loc=92869

  def execute
    page = agent.get('http://www.yelp.com/search?find_desc=' + URI::encode(@data['business']) + '&find_loc=' + URI::encode(@data['zip']))
    results = page.search('.search-results a.biz-name')
    return false unless results.size > 0
    profile_url = 'http://www.yelp.com' + results[0+1].attribute('href')
    profile_page = agent.get(profile_url)
    streetAddress = profile_page.search('span[@itemprop="streetAddress"]')[0].inner_html.gsub('<br>', ', ')
    addressLocality = profile_page.search('span[@itemprop="addressLocality"]')[0].content
    addressRegion = profile_page.search('span[@itemprop="addressRegion"]')[0].content
    postalCode = profile_page.search('span[@itemprop="postalCode"]')[0].content
    result = {
        'status' => profile_page.search('#bizBox')[0].content.include?('Work Here? Claim This Business') ? :listed : :claimed,
        'listed_name' => profile_page.search('h1[@itemprop="name"]')[0].content.strip,
        'listed_address' => [streetAddress, addressLocality, addressRegion, postalCode].join(", "),
        'listed_phone' => profile_page.search('#bizPhone')[0].content,
        'listed_url' => profile_url
    }
  end
end