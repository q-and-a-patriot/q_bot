require 'twitter'

class QBot
  attr_reader :map

  def initialize(file)
    file = File.open(file)
    @map = JSON.parse file.read

    $stdout.sync = true
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['consumer_key']
      config.consumer_secret = ENV['consumer_secret']
      config.access_token = ENV['access_token']
      config.access_token_secret = ENV['access_token_secret']
    end

  end

  def post_thread(arr)
    first_tweet = arr[0]
    to_reply = @client.update(first_tweet)
    puts "Printing first tweet in Q_line:"
    puts first_tweet
    arr[1..-1].each do | tweet |
      puts "Printing Tweet"
      puts tweet
      wait = 15+rand(61)
      puts "Sleeping for #{wait} seconds"
      sleep(wait)

      to_reply = @client.update(tweet, in_reply_to_status_id: to_reply.id)
    end
  end

  def start(post_num=0)
    loop do
      puts "Posting Q MSG # #{post_num}"
      post = @map[post_num]
      post_q_msg post
      post_num += 1
      post_num %= 352
      wait = 2700 + rand(8100)
      puts "Sleeping for #{wait} seconds"
      sleep( wait )

    end
  end

  def post_q_msg(q_msg)
    q_msg.each do |q_line|
      puts "Posting Q Line"
      puts q_line
      post_thread q_line
      wait = 241 + rand(402)
      puts "Sleeping for #{wait} seconds"
      sleep(wait)

    end
  end

  def get_last_tweet
    t = @client.user_timeline('MommaDeplorable', count: 1)[0]
    return t.text
  end

  def parse_number_from_last_tweet
    t = get_last_tweet
    num = t.split("\n")[1].split("_")[0].to_i
    if num == -1
      puts "Can't locate proper tweet, choosing random to begin."
      return rand(348)
    else
      puts "Beginning with q_post #{num}"
      num
    end
  end

end

def random
 [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
end

bot = QBot.new("map.json")

bot.start(bot.parse_number_from_last_tweet)
#puts bot.parse_number_from_last_tweet

#print bot.map[2]
