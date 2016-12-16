require "sinatra"
require_relative "../../app/common/filer"

class Application < Sinatra::Base

  def initialize
    super()
  end  

  #Load authentication details
  keys = {}
  keys = YAML::load_file('./config/accounts.yaml')
  set :gnip_account_name, keys['gnip']['account_name']
  set :gnip_user_name, keys['gnip']['user_name']
  set :gnip_password, keys['gnip']['password']
  set :consumer_key, keys['engagement_app']['consumer_key']
  set :consumer_secret, keys['engagement_app']['consumer_secret']
  set :access_token, keys['engagement_app']['access_token']
  set :access_token_secret, keys['engagement_app']['access_token_secret']
  
  get '/' do
    erb :dashboard
  end

  #Gnip Search API -------------------------------------------------------------

  #This will point to UI for creating a Search request. 
  get '/create_request' do

    #Collecting the following
    #query, fromDate, toDate
    #future options? maxResults, searchType

  end

  get '/display_search_results' do

  	puts "Calling get_tweets with #{settings.gnip_user_name}"

    #query = "from%3Asnowman" #Need to URL encode
    query = "snowman" 

  	@tweets = SearchTweet.query(query, settings)
    puts "Tweets: #{@tweets}"
	
	#Save Tweet IDs
	filer = Filer.new
	filer.write_ids('tweet_ids.dat', 'tweet_id', @tweets)
	filer.write_ids('user_ids.dat', 'user_id', @tweets)
    
	erb :search_results

  end

  get '/tweet_details' do

    puts "Calling Tweet JSON display"

    erb :tweet_details

  end 


  #Gnip Engagement API ---------------------------------------------------------
  get '/get_engagements' do
    puts "Calling get_engagements with #{settings.consumer_key} and #{@my_tweets}"
	
	filer = Filer.new
	tweet_ids = filer.read_ids('tweet_ids.dat')
	
    results = Engagement.get_metrics(tweet_ids, settings)

    erb :engagement_results, :locals => {:results => results}
  end

  #Gnip Audience API ---------------------------------------------------------
  get '/get_audience' do
	 filer = Filer.new
	 user_ids = filer.read_ids('user_ids.dat')

	 results = Audience.create_and_query_audience(user_ids, settings)
	 
	 erb :audience_results, :locals => {:results => results}
	 
	 
  end

  get '/show_audience' do
   puts 'show_audience'
  end

end