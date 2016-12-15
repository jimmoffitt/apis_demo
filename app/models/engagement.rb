require 'json'
require 'ostruct'
require 'yaml'
require 'date'

API_URL = "http://twitter.com/search"
API_KEY = "442eba5b3e3a3ae8ead5698479bcdaa8"

class SearchTweet
  def self.for(query)
    raw_data = Faraday.get("#{API_URL}/forecast?q=#{query}&APPID=#{API_KEY}").body
    tweet_data = JSON.parse(raw_data, object_class: OpenStruct)
    
  end
end