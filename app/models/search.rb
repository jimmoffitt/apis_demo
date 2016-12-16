require 'json'

class SearchTweet
  
     def self.query(query, settings)
		
		tweets = []
		
		next_token = 'first request'

        conn = Faraday.new("https://gnip-api.twitter.com")
        conn.basic_auth(settings.gnip_user_name, settings.gnip_password)
		
		#First call.
		puts "Making first call..."
		
		data = { :query => query, :maxResults => 500 }
		
      	path = "/search/30day/accounts/#{settings.gnip_account_name}/prod.json"
		
		response = conn.post(path, data.to_json, {'Content-Type' => 'application/json'})
		#response = conn.get("/search/30day/accounts/#{settings.gnip_account_name}/prod.json?query=#{query}&maxResults=500")
		
		puts response.status
		
        results_data = JSON.parse(response.body)
		

		
		puts "Got #{results_data['results'].count} Tweets. Next Token: #{results_data['next']}"

		results_data['results'].each do |tweet|
		   #puts "new Tweet object with #{data}"
		   tweets << tweet
		   #puts "New Tweet object with #{tweet.id}"
		end
		
		puts "NEXT TOKEN: #{next_token}"
		
		while not next_token.nil? do
		   
		   begin
		       next_token = results_data['next']
		   rescue
			  next_token = nil
		   end	  
		   
		   puts "2 Next token: #{next_token}"
			  
		   if not next_token.nil?
			  puts "Making call with #{next_token}..."

			  data = { :query => query, :maxResults => 500, :next => next_token}
			  response = conn.post(path, data.to_json, {'Content-Type' => 'application/json'})
			  #response = conn.get("/search/30day/accounts/#{settings.gnip_account_name}/prod.json?query=#{query}&maxResults=500&next=#{next_token}")
		
			  results_data = JSON.parse(response.body)

			  results_data['results'].each do |tweet|
				 #puts "new Tweet object with #{data}"
				 tweets << tweet
				 #puts "New Tweet object with #{tweet.id}"
			  end
		   end
		end
		
		puts "LEAVING WITH #{tweets.count} Tweets"
		
		tweets
    end
end