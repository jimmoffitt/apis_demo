class Tweet
  attr_reader :id, :actor, :body
  def initialize(data)
  	@time  = data['postedTime']
    @id    = data['id'].split(':')[-1]
    @actor_id = data['actor']['id'].split(':')[-1] 
    @actor = data['actor']['preferredUsername']
    @body  = data['body']

    #puts "#{@id} by #{@actor} with #{@body}"
  end
end