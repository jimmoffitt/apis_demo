# apis_demo
A collection of demos: Tweets --> Engagement metrics --> Audience analysis

Written in Ruby using Sinatra web framework.

* 30-Day Search API --> @tweets
* @tweets.id --> Engagement API --> Top 10 Tweets
* @tweets.actor.id --> Audience API (if >= 500)

TO DOs:

[X] Basic Auth call for 30-day Search.

[X] Oauth with Faraday? No. Use Oauth gem? Yes.

[X] Add in Engagement API. Refactor Engagement API client and plug in? Probably not?

[X] Add in Audience API. Refactor Audience API client and plug in? Probably not?

[X] Passing Tweet/User IDs between models.

[X] Manage multiple requests.

[] Add in Engagement client's 'Top Tweets'. 

[] Store Tweets/metadata in mongodb? Postgres?

[] UI for defining search.

[] Progress bar for many-requests sequences.

[] UI status updates.
