require 'mechanize'

class AbstractScrapper
  def initialize(data)
    @data = data
  end

  def need_browser?
    false
  end

  def agent
    if @agent.nil?
      @agent = Mechanize.new
    end
    @agent
  end
end