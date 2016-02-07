require 'sinatra'
require 'rubygems'
require 'httparty'
require 'tweetstream'

class CoREsriAPI

  include HTTParty
  base_uri 'http://maps.raleighnc.gov/arcgis/rest/services'
  default_params :output => 'json'
  format :json

  def self.getSpecialEventData(precision)
  	data4waze = []
  	query = { "where" => "1=1", "outSR" => "4326", "geometryPrecision" => precision, "f" => "json", "outFields" => "*"}
    response = get('/SpecialEvents/SpecialEventsView/MapServer/0/query', :query => query) # we could add headers here if needed HTTParty.post("https://www.acb.com/api/v2/market/LTC_BTC/", :query => query, :headers => headers )

    if response.success?
  		 response['features'].each do |object|
		   	# puts object['attributes']
		    # data4waze << object['attributes']
		    puts object['geometry']
		    data4waze << object['geometry']
		 end		
	   	 return data4waze
	   	 #return response
	else
		raise response.response
	end
  end

end


get '/' do
  "Hello World!"
end

get '/getEventData' do
	 CoREsriAPI.getSpecialEventData('6').to_json
end

get '/crashtweets' do

TweetStream.configure do |config|
  config.consumer_key       = 'O9wsZfidXPUtnNB21HCxrrXEq'
  config.consumer_secret    = 'j9njg9Leu935sbipDz8jklPNfi7ipdV3DyKRLb2xBSwErv4vEp'
  config.oauth_token        = '7374632-D07EYGE0IkClZj7ub9g2opd4l53MCaQuM61WuJfz6T'
  config.oauth_token_secret = 'tqd0MN5tb81lID9v8izSCEA77RnzMsg6uiE24qBKlfX3j'
  config.auth_method        = :oauth
end

# Use 'follow' to follow a group of user ids (integers, not screen names)
TweetStream::Client.new.follow(20647123, 7374632) do |status|
  puts "#{status.text}"
  puts "chad"
end
# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.
TweetStream::Client.new.sample do |status|
  # The status object is a special Hash with
  # method access to its keys.
  puts "#{status.text}"
  puts "carla"
end
end

