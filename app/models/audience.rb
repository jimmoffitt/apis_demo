require 'json'
require 'yaml'
require 'oauth'
require 'zlib'


#OK, the first goal here is to simply make a call to the /totals endpoint with @tweets collection.
class Audience

	attr_accessor :api

	def self.initialize
		puts 'Spinning up Audience API object.'
    end 	

    def self.build_segment_request(users)

    	request = {}
    	request['user_ids'] = users

        #TODO - Hardcoded
       	request['groupings'] = {}
       request.to_json
  
    end


    def self.make_post_request(users)

    	uri_path = "/insights/audience/"

		begin

			get_api_access if @api.nil? #token timeout?

			request = assemble_request(users)

			puts "REQUEST: #{request}"
 
            result = @api.post(uri_path, request, {"content-type" => "application/json", "Accept-Encoding" => "gzip"})
		 
		    #Unzip result body, which is gzip.
		    gz = Zlib::GzipReader.new( StringIO.new( result.body ) )
		    result.body = gz.read

		    if result.code.to_i > 201
			   puts 'ERROR with Audeience API request.'
		    end

		    puts result.body

            result.body
	    rescue
		    puts "Error making POST request to Audience API. "
		    puts response.body
	    end
    end	

	def self.get_api_access(keys)

      puts "OAuth authentication!"

      base_url = 'https://data-api.twitter.com'
    
	  consumer = OAuth::Consumer.new(keys.consumer_key, keys.consumer_secret, {:site => base_url})
	  token = {:oauth_token => keys.access_token, :oauth_token_secret => keys.access_token_secret }

	  @api = OAuth::AccessToken.from_hash(consumer, token)

    end


    def self.build_segment(users, keys)

   	  @api = get_api_access(keys)

   	  puts "Making build segment request."

  	  response = make_post_request(tweets)
    
    end

end