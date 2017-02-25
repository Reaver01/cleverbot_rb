require 'cleverbot/api'

module Cleverbot
  # A conversation with the API
  class Conversation
    # @return [String] this conversation's hash, assigned by cleverbot
    attr_reader :cs

    # @return [String] the input given to this interaction
    attr_reader :input

    # @return [String] the output to this interaction
    attr_reader :output
    alias response output

    # @return [Time] timestamp of this interaction
    attr_reader :timestamp

    # @return [Array<Hash>] interaction history in this conversation
    attr_reader :interactions

    # @return [Integer] number of interactions
    attr_reader :interaction_count

    # The API returns a lot of other arbitray information that may or may not
    # be useful. The most common pieces of data have direct instance methods ;
    # for anything else, look inside this hash.
    # @return [Hash] all raw data about this conversation
    attr_reader :data

    # Start a new conversation with the API
    # @param key [String] the API key used for this conversation
    def initialize(key)
      @key = key
    end

    # Replies to this conversation thread.
    # @param message [String] the message to send
    # @raise [ArgumentError] if message is empty
    def reply(message)
      raise ArgumentError, 'message cannot be empty' if message.empty?
      update_data API.get_reply @key, message, cs
      output
    end

    # Internally updates this conversation's data
    # @param data [Hash] an API response hash to update from
    private def update_data(data)
      @data = data

      @cs = data['cs']

      @input = data['input']

      @output = data['output']

      @timestamp = Time.new(
        data['time_year'],
        data['time_month'],
        data['time_day'],
        data['time_hour'],
        data['time_minute'],
        data['time_second'],
        0
      )

      @interactions = []

      data.select { |k, _| k.start_with? 'interaction_' }.each do |k, v|
        next if v.empty? || k == 'interaction_count'

        index = k[/\d+/].to_i - 1

        @interactions[index] ||= {}

        if k.match?(/interaction_\d+$/)
          @interactions[index][:input] = v
        elsif k.match?(/interaction_\d+_other$/)
          @interactions[index][:output] = v
        end
      end

      @interaction_count = data['interaction_count'].to_i
    end
  end
end
