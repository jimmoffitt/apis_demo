require "sinatra"

class Application < Sinatra::Base
 
  #Load authentication details
  keys = {}
  keys = YAML::load_file('./config/accounts_private.yaml')
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

    query = "snowman" #Need to URL encode

  	@tweets = SearchTweet.query(query, settings)

    erb :search_results

  end

  get '/tweet_details' do

    puts "Calling Tweet JSON display"

    erb :tweet_details

  end 


  #Gnip Engagement API ---------------------------------------------------------
  get '/get_engagements' do
    puts "Calling get_engagements with #{settings.consumer_key}"
  end

  get '/show_engagements' do
   puts 'show_engagements'
  end

  #Gnip Audience API ---------------------------------------------------------
  get '/get_audience' do
    puts "Calling get_audience with #{settings.consumer_key}"
  end

  get '/show_audience' do
   puts 'show_audience'
  end

end