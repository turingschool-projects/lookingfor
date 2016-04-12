class AngelListService
  attr_reader :connection

  def initialize
    @connection = Faraday.new(:url => 'https://angel.co/api') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

end
