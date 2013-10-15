class Twitter < AbstractScrapper

  def execute
    page = agent.get('http://twitter.com/search?mode=users&q=' + URI::encode(@data['business']))
    results = page.search('.stream-items a.js-user-profile-link')
    return false unless results.size > 0
    profile_url = 'http://twitter.com' + page.search('.stream-items a.js-user-profile-link')[0].attribute('href')
    profile_page = agent.get(profile_url)
    result = {
        'status' => profile_page.search('.verified-link').size > 0 ? :claimed : :listed,
        'listed_address' => profile_page.search('.location.profile-field')[0].content.strip,
        'listed_name' => profile_page.search('.fullname span')[0].content,
        'listed_phone' => '',
        'listed_url' => profile_url
    }
  end
end