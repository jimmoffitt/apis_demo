require 'json'
require 'yaml'
require 'oauth'
require 'zlib'

#OK, the first goal here is to simply make a call to the /totals endpoint with @tweets collection.
class Engagement
   
    MAX_TWEET_IDS_PER_REQUEST = 250
	GROUPING_NAME = 'my_single_group'

	attr_accessor :api

	def self.initialize
		puts 'Spinning up Engagement API object.'
    end 	

    def self.assemble_request(tweets)

    	request = {}
    	request['tweet_ids'] = tweets

        #TODO - Hardcoded
    	request['engagement_types'] = []
    	request['engagement_types'] << "impressions"
    	request['engagement_types'] << "engagements"
    	request['engagement_types'] << "favorites"

    	request['groupings'] = {}
    	request['groupings'][GROUPING_NAME] = {}
    	request['groupings'][GROUPING_NAME]['group_by'] = []

    	request['groupings'][GROUPING_NAME]['group_by'] << 'tweet.id'
    	request['groupings'][GROUPING_NAME]['group_by'] << 'engagement.type'

        request.to_json 
  
    end

    def self.make_post_request(tweets)

    	uri_path = "/insights/engagement/totals"

		begin

			#get_api_access(keys) if @api.nil? #token timeout?

			request = assemble_request(tweets)

			#puts "REQUEST: #{request}"
 
            result = @api.post(uri_path, request, {"content-type" => "application/json", "Accept-Encoding" => "gzip"})
		 
		    #Unzip result body, which is gzip.
		    gz = Zlib::GzipReader.new( StringIO.new( result.body ) )
		    result.body = gz.read

		    if result.code.to_i > 201
			   puts 'ERROR with Engagement API request.'
		    end

            JSON.parse(result.body)
			   
	    rescue
		    puts "Error making POST request to Engagement API. "
		    puts response.body
	    end
    end	

	def self.get_api_access(keys)

      base_url = 'https://data-api.twitter.com'
    
	  consumer = OAuth::Consumer.new(keys.consumer_key, keys.consumer_secret, {:site => base_url})
	  token = {:oauth_token => keys.access_token, :oauth_token_secret => keys.access_token_secret }

	  @api = OAuth::AccessToken.from_hash(consumer, token)

    end

    def self.get_metrics(tweets, keys)

   	  @api = get_api_access(keys)
	  
	  #Potentially making multiple calls to Engagement API.
	  responses = []
	  
	  
	  tweets.each_slice(MAX_TWEET_IDS_PER_REQUEST) do |tweet_set|
		 response = make_post_request(tweet_set)
		 responses << response
	  end
	   
	   
	  #Re-assemble multiple responses into one.
	  #TODO: Here we could navigate each response and combine on GROUPING_NAME
	  
	  responses[0].to_json
	  
	   
    end

end