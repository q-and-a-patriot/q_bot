require 'twitter'
num = 1
client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['consumer_key']
  config.consumer_secret = ENV['consumer_secret']
  config.access_token = ENV['access_token']
  config.access_token_secret = ENV['access_token_secret']
end
loop do
  "Hello! Time for some tweeting!"
  puts "Tweet Number: "+num
  num = num + 1
  tweet = [*('a'..'z'),*('0'..'9')].shuffle[0,8].join

  t = client.user_timeline('Q_AND_A_PATRIOT', count: 1)[0]
  iter = t.text[-1, 1]
  iter = iter.to_i + 1

  t = client.update(tweet+"_"+iter.to_s)

  puts t.text
  puts "Going to sleep for 150 seconds"
  sleep(150)
end
