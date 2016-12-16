# apis_demo
A collection of demos: Tweets --> Engagement metrics --> Audience analysis

Written in Ruby using Sinatra web framework.

* 30-Day Search API --> @tweets
* @tweets.id --> Engagement API --> Top 10 Tweets
* @tweets.actor.id --> Audience API (if >= 500)

TO DOs:

[X] Basic Auth call for 30-day Search.

[X] Oauth with Faraday? No. Use Oauth gem? Yes.

[] Passing Tweet/User IDs between models.

[] UI for defining search.

[] Manage multiple requests.

[] Store Tweets/metadata in mongodb?

[] Refactor Engagement API client and plug in?

[] Refactor Audience API client and plug in? 

[] Progress bar for many-requests sequences.

[] UI status updates.
