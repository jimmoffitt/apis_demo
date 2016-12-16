require 'json'
require 'yaml'
require 'oauth'
require 'zlib'

#OK, the first goal here is to simply make a call to the /totals endpoint with @tweets collection.
class Engagement

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
    	request['groupings']['my_single_group'] = {}
    	request['groupings']['my_single_group']['group_by'] = []

    	request['groupings']['my_single_group']['group_by'] << 'tweet.id'
    	request['groupings']['my_single_group']['group_by'] << 'engagement.type'

        request.to_json 
  
    end

    def self.make_post_request(tweets)

    	uri_path = "/insights/engagement/totals"

		begin

			get_api_access if @api.nil? #token timeout?

			request = assemble_request(tweets)

			#puts "REQUEST: #{request}"
 
            result = @api.post(uri_path, request, {"content-type" => "application/json", "Accept-Encoding" => "gzip"})
		 
		    #Unzip result body, which is gzip.
		    gz = Zlib::GzipReader.new( StringIO.new( result.body ) )
		    result.body = gz.read

		    if result.code.to_i > 201
			   puts 'ERROR with Engagement API request.'
		    end

		    #puts result.body

            result.body
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

      if tweets.nil? or tweets.count == 0
	      tweets = []
	      tweets << '806981306773020672'
	      tweets << '806980377189425152'
	      tweets << '806972782206734336' 
	  end

      puts "get_metrics with #{tweets} and #{keys}"	

   	  @api = get_api_access(keys)

  	  response = make_post_request(tweets)
    
	  response
	   
    end

end