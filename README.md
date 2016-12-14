# apis_demo
A collection of demos: Tweets --> Engagement metrics --> Audience analysis

Written in Ruby, using Sinatra web app framework.

* 30-day Search API --> @tweets
* @tweets.ids --> Engagement API --> rendering top 10 Tweets.
* @tweets.actor.ids --> Audience API (if >= 500)

To-dos:

* add oauth support
* refactor engagement client and plug it in.
* refactor audience client and plug it in.
* progress bars for paging requests (search.next_token, engagement.get_metrics).
