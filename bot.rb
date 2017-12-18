require 'twitter'

tweet = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['consumer_key']
  config.consumer_secret = ENV['consumer_secret']
  config.access_token = ENV['access_token']
  config.access_token_secret = ENV['access_token_secret']
end

f = File.open("iter")
iter = f.read
f.close

client.update(tweet+"_"+iter.strip)

f = File.open("iter", "w")
f.write(iter.to_i+1)
f.close
