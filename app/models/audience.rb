#Simple demo of Audience.
#Builds single Segment on a single Tweet Collection, then builds a single Audience,a nd queries it. 

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

    def self.create_segment_request(users)

    	request = {}
    	request['user_ids'] = users

        #TODO - Hardcoded
       	request['groupings'] = {}
       request.to_json
  
    end

    def self.make_post_request(request, destination, object_id = nil, extra = nil) #object_id is either a segment or audience id for api uri_path.

    	uri_path = "/insights/audience/#{destination}"
		
		uri_path = "#{uri_path}/#{object_id}" if not object_id.nil?

		uri_path = "#{uri_path}/#{extra}" if not extra.nil?

		puts uri_path
		
		begin

			#get_api_access if @api.nil? #token timeout?

			puts "REQUEST: #{request}"
 
            result = @api.post(uri_path, request, {"content-type" => "application/json"})
		 
			puts "Result: #{result}"
			puts "Result body: #{result.body}"
			puts "Result code: #{result.code}"
			
		    #Unzip result body, which is gzip.
		    #gz = Zlib::GzipReader.new( StringIO.new( result.body ) )
		    #result.body = gz.read

		    if result.code.to_i > 201
			   puts 'ERROR with Audience API request.'
		    end

            JSON.parse(result.body)

	    rescue
		    puts "Error making POST request to Audience API. "
		    puts result.body
	    end
    end	

	def self.get_api_access(keys)

      puts "OAuth authentication!"

      base_url = 'https://data-api.twitter.com'
    
	  consumer = OAuth::Consumer.new(keys.audience_consumer_key, keys.audience_consumer_secret, {:site => base_url})
	  token = {:oauth_token => keys.audience_access_token, :oauth_token_secret => keys.audience_access_token_secret }

	  @api = OAuth::AccessToken.from_hash(consumer, token)

	end
	
	
	def self.create_segment_request(name)
	   
	   request = {}
	   request['name'] = name
	   request.to_json
	
	end
	
	def self.add_users_to_segment_request(user_ids)
	   
	   request = {}
	   request['user_ids'] = user_ids
	   request.to_json
	   
	end

    def self.create_audience_request(name, segment_id)

	   request = {}
	   request['name'] = name
	   request['segment_ids'] = []
	   request['segment_ids'] << segment_id
	   request.to_json
	   
    end

	def self.query_audience_request(audience, groupings)
	end
	
	def self.build_groupings
	   
	   groupings = {}
	   
	   groupings['groupings'] = {}
	   
	   groupings['groupings']['age'] = {}
	   groupings['groupings']['age']['group_by'] = []
	   groupings['groupings']['age']['group_by'] << "user.age"

	   groupings['groupings']['gender'] = {}
	   groupings['groupings']['gender']['group_by'] = []
	   groupings['groupings']['gender']['group_by'] << "user.gender"

	   groupings['groupings']['language'] = {}
	   groupings['groupings']['language']['group_by'] = []
	   groupings['groupings']['language']['group_by'] << "user.language"

	   groupings['groupings']['interest'] = {}
	   groupings['groupings']['interest']['group_by'] = []
	   groupings['groupings']['interest']['group_by'] << "user.interest"

	   groupings['groupings']['country_metro'] = {}
	   groupings['groupings']['country_metro']['group_by'] = []
	   groupings['groupings']['country_metro']['group_by'] << "user.location.country"
	   groupings['groupings']['country_metro']['group_by'] << "user.location.metro"

	   groupings.to_json
	end


	def self.create_and_query_audience(users, keys)
   
	  if users.count < 500
		 return "Not enough users to create audience. The minimum is 500. Have #{users.count}."
      end

	  #TODO: need to check for existing Segments/Audiences? Delete 'demo' objects each time?
	  
	  
   	  @api = get_api_access(keys)

   	  puts "Creating Segment, Audience, and querying it."

	  #Create Segment.
	  request = create_segment_request('demo')
	  response = make_post_request(request, 'segments')
	  puts "Response: #{response}"
	  segment_id = response['id']
	  
	  puts "Built Segment #{segment_id}"
	   
	  #Add User IDs to Segment.
	  puts "Adding users to Segment #{segment_id}."
	  request = add_users_to_segment_request(users)
	  response = make_post_request(request, 'segments', segment_id, 'ids')
	  	   
	  #Create Audience.
	  puts "Creating Audience with #{segment_id}."
	  request = create_audience_request('demo', segment_id)
	  response = make_post_request(request, 'audiences')
	  audience_id = response['id']

	  puts "Built Audience #{audience_id}"
	  
	  #Create Audience.
	  request = build_groupings
	  puts "Querying Audience with #{audience_id} with #{request}."
	  response = make_post_request(request, 'audiences', audience_id, 'query')

      response.to_json

	end

end