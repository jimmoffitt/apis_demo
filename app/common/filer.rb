class Filer
   
   def write_ids(file_name, id_type, tweets)
	  
	  ids = []
	  
	  tweets.each do |tweet|
		 if id_type == 'tweet_id'
			ids << tweet['id'].split(':')[-1]
		 else
			ids << tweet['actor']['id'].split(':')[-1]
		 end
	  end

	  File.open(file_name, "w+") do |f|
		 ids.each { |element| f.puts(element) }
	  end
	  
   end   
   def read_ids(file_name)
		 
	  ids = []

	  file = File.open(file_name, "r")
	  for line in file

		 # Now insert the data stored in the line variable into the array
		 ids.push(line)

	  end

	  file.close
	  
	  ids

   end
end