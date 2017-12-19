require 'CSV'
require 'pry'
require 'json'

file_location = "map.csv"


class FormatMap

  def initialize(location)
    @data = CSV.read(location)
    @transposed = @data.transpose
    @msg_start = []
    @hash_tags = ["#Trump", "#MAGA", "#Qanon", "#Q", "#TheStorm",
                  "#CBTS", "#FolllowTheWhiteRabbit", "#QClearance",
                  "#TickTock", "#Breadcrumbs", "#TheStormIsUponUs",
                  "#TheStormIsHere", "#CalmBeforeTheStorm", "#DonaldTrump",
                  "#Redpill", "#DrainTheSwamp", "#MuellerTime", "#Mueller",
                  "#AmericaFirst", "@realdonaldtrump", "#Sessions",
                  "#TheStormIsComing", "#TheStormHasArrived",
                  "#SealedIndictments", "#TheGreatAwakening"]

    @transposed[1].each_with_index do |cell, i|
      if cell.nil?
        cell = ""
      end
      if cell[0,2] == ">>"
        @msg_start << i
      end
    end
  end

  def full_q_msg(start)

    ceiling = @msg_start[start]
    if @msg_start[start] == @msg_start.last
      floor = @data.length
    else
      floor = @msg_start[start+1]
    end
    length = floor - ceiling
    output = @data[ceiling, length]
  end

  def threaded_msg(msg_num)
    full_msg = full_q_msg msg_num
    output_array =[]

    full_msg[1..-1].each_with_index do | line, index |
      # remove extra cells
      line = line[1,3]
      output_array << threadify(line, index, msg_num, full_msg)
    end
    output_array
  end

  def threadify(line, index, msg_num, full_msg)
    tweet_arr = []
    q_msg_text = line[0]
    concise_answer = line[1]
    long_answer = line[2]

    first_line = %(BEGIN_Q_MSG_#{msg_num+1}_#{index+1}
#{full_msg[0][3]}
#{full_msg[0][1]}
)
    expl_line = %(EXPL_Q_MSG_#{msg_num+1}_#{index+1}
)
    further_detail_line = %(DETAIL_Q_MSG_#{msg_num+1}_#{index+1}
)
    hashtags ="#Trump #MAGA #Qanon #Q #TheStorm #CBTS #FolllowTheWhiteRabbit #QClearance #TickTock #Breadcrumbs \n\n"
    if q_msg_text
      tweet_arr.concat split_and_format_msg(get_hashtags(5) + q_msg_text, first_line)
    end
    if concise_answer
      tweet_arr.concat split_and_format_msg(get_hashtags(4) + concise_answer, expl_line)
    end
    if long_answer
      tweet_arr.concat split_and_format_msg(get_hashtags(4) + long_answer, further_detail_line)
    end
    return tweet_arr
  end

  def get_hashtags(num)
    if num > @hash_tags.length
      num = @hash_tags.length
    end
    return @hash_tags.shuffle()[0,num].join(" ") + "\n\n"
  end

  def split_and_format_msg(msg, prepend_line)
    out = []
    chunked_msg = []
    if msg.length > 260-(prepend_line.length+7)
      chunked_msg = chunk(msg, 260-(prepend_line.length+5))
    else
      chunked_msg << msg
    end
    chunked_msg.each_with_index do |chunk, i|
      full_msg = prepend_line +"\n[#{i+1}/#{chunked_msg.length}] "+chunk
      out << full_msg
    end

    return out
  end

  def chunk(string, size)
    arr = []
    until string.length < size
      last_space_index = string[0, size].rindex(/[\s\r\n\t]/)
      arr << string[0..last_space_index]
      string = string[last_space_index+1..-1]
    end
    arr << string
  end

  def format_all
    output = []
    @msg_start.each_with_index do | msg_num, index |
      output << threaded_msg(index)
    end
    return output

  end
end

output = FormatMap.new(file_location)

out = output.threaded_msg(3)[1]
print out

out = output.format_all

json_hash = out.to_json

puts json_hash

file = File.open("map.json", "w")

file.write json_hash

file.close

# TODO
# Comment everything
