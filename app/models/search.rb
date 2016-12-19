require 'json'

class SearchTweet
  
     def self.query(settings, query, fromdate, todate)
		
		tweets = []
		
		next_token = 'first request'

        conn = Faraday.new("https://gnip-api.twitter.com")
        conn.basic_auth(settings.gnip_user_name, settings.gnip_password)

		data = {}
		data[:query] = query
		data[:maxResults] = 500
		data[:fromDate] = fromdate if fromdate != ''
		data[:toDate] = todate if todate != ''
		#puts "DATA: #{data}"
		
      	path = "/search/30day/accounts/#{settings.gnip_account_name}/prod.json"
		
		response = conn.post(path, data.to_json, {'Content-Type' => 'application/json'})

        results_data = JSON.parse(response.body)

		results_data['results'].each do |tweet|
		   tweets << tweet
		end
		
		while not next_token.nil? do
		   
		   begin
		       next_token = results_data['next']
		   rescue
			  next_token = nil
		   end	  
		   
		   if not next_token.nil?

			  data = { :query => query, :maxResults => 500, :next => next_token}
			  response = conn.post(path, data.to_json, {'Content-Type' => 'application/json'})

			  results_data = JSON.parse(response.body)

			  results_data['results'].each do |tweet|
				 tweets << tweet
			  end
		   end
		end
		
		#puts "Leaving with #{tweets.count} Tweets"
		
		tweets
    end
end