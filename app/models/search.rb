require 'json'
require 'ostruct'

class SearchTweet
  
     def self.query(query, settings)

        conn = Faraday.new(url: "https://gnip-api.twitter.com") 
        conn.basic_auth(settings.gnip_user_name, settings.gnip_password)
        response = conn.get("/search/30day/accounts/#{settings.gnip_account_name}/prod.json?query=#{query}&maxResults=50") 

        results_data = JSON.parse(response.body) 

        #puts results_data

        puts results_data['results'].count

        results_data['results'].each do |data|
            #puts "new Tweet object with #{data}"
        	tweet = Tweet.new(data)
            #puts "New Tweet object with #{tweet.id}"
        end 	
    end 	
end