require 'twitter'

tweet = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['consumer_key']
  config.consumer_secret = ENV['consumer_secret']
  config.access_token = ENV['access_token']
  config.access_token_secret = ENV['access_token_secret']
end

client.update(tweet)


