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


    def self.make_post_request(users, object_id = nil) #object_id is either a segment or audience id for api uri_path.

    	uri_path = "/insights/audience/"
		
		uri_path = "#{uri_path}#{object_id}/" if not object_id.nil? 
		
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

            JSON.parse(result.body)

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

	   groupings['age'] = {}
	   groupings['age']['group_by'] = []
	   groupings['age']['group_by'] << "user.age"

	   groupings['gender'] = {}
	   groupings['gender']['group_by'] = []
	   groupings['gender']['group_by'] << "user.gender"

	   groupings['language'] = {}
	   groupings['language']['group_by'] = []
	   groupings['language']['group_by'] << "user.language"

	   groupings['interest'] = {}
	   groupings['interest']['group_by'] = []
	   groupings['interest']['group_by'] << "user.interest"

	   groupings['country_metro'] = {}
	   groupings['country_metro']['group_by'] = []
	   groupings['country_metro']['group_by'] << "user.location.country"
	   groupings['country_metro']['group_by'] << "user.location.metro"

	   groupings.to_json
	end


	def self.create_and_query_audience(users, keys)

	  if users.count < 500
		 return "Not enough users to create audience. The minimum is 500. Have #{users.count}."
      end
	   
   	  @api = get_api_access(keys)

   	  puts "Creating Segment, Audience, and querying it."

	  #Create Segment.
	  request = create_segment_request('demo')
	  response = make_post_request(request)
	  segment_id = response['id']
	   
	  #Add User IDs to Segment.
	  request = add_users_to_segment_request(users)
	  response = make_post_request(request, segment_id)
	  	   
	  #Create Audience.
	  request = create_audience_request('demo', segment_id)
	  response = make_post_request(request)
	  audience_id = response['id']
	  
	  #Create Audience.
	  request = build_groupings
	  response = make_post_request(request, audience_id)

      response

	end

end