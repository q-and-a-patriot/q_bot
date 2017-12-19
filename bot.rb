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

    arr[1..-1].each do | tweet |
      puts "Printing Tweet #{tweet}"
      sleep(3)

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
      sleep(2700)

    end
  end

  def post_q_msg(q_msg)
    q_msg.each do |q_line|
      puts "Posting Q Line"
      puts q_line
      post_thread q_line
      sleep(60)

    end
  end

  def get_last_tweet
    t = @client.user_timeline('Q_AND_A_PATRIOT', count: 1)[0]
    return t.text
  end

  def parse_number_from_last_tweet
    t = get_last_tweet
    num = t.split(" ")[0].split("_")[-2].to_i - 1
    num
  end

end

def random
 [*('a'..'z'),*('0'..'9')].shuffle[0,8].join
end

bot = QBot.new("map.json")

bot.start(bot.parse_number_from_last_tweet)
