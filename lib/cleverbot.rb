require 'json'
require 'rest-client'

# Defines Cleverbot.
class Cleverbot
  # @return [String] The API Key for the instance.
  attr_reader :api_key

  # Creates a new instance of the Cleverbot.
  # @param api_key [String] The API key for the Cleverbot API.
  def initialize(api_key)
    @api_key = api_key
    url = "http://cleverbot.com/getreply?key=#{@api_key}"
    response = { 'output' => nil }
    while response['output'].nil?
      response = RestClient.get(url)
      response = JSON.parse(response)
    end
    @cs = response['cs']
  end

  # Sends the bot a message and returns its response.
  # @param str [String] The message to send to the bot.
  # @return [String] The bot's response, or its error message.
  def say(str)
    url = "http://cleverbot.com/getreply?key=#{@api_key}&input=#{str}&cs=#{@cs}"
    response = { 'output' => nil }
    x = 0
    while response['output'].nil? && x < 10
      response = JSON.parse(RestClient.get(url))
      x += 1
    end
    @cs = response['cs']
    check_reset(response['interaction_50'])
    response['output']
  end

  def check_reset(i50)
    unless i50.nil?
      url = "http://cleverbot.com/getreply?key=#{@api_key}"
      response = { 'output' => nil }
      while response['output'].nil?
        response = RestClient.get(url)
        response = JSON.parse(response)
      end
      @cs = response['cs']
    end
end
