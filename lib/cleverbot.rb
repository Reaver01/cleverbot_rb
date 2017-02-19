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
    url = "http://cleverbot.com/getreply?key=#{@api_key}&wrapper=cleverbot_rb"
    response = { 'output' => nil }
    10.times do
      response = RestClient.get(url)
      response = JSON.parse(response)
      break unless response['output'].nil?
    end
    @cs = response['cs']
  end

  # Sends the bot a message and returns its response.
  # @param str [String] The message to send to the bot.
  # @return [String] The bot's response, or its error message.
  def say(str)
    url = "http://cleverbot.com/getreply?key=#{@api_key}&input=#{str}&cs=#{@cs}&wrapper=cleverbot_rb"
    response = { 'output' => nil }
    10.times do
      begin
        response = RestClient.get(url)
        response = JSON.parse(response)
      rescue
        reset
      end
      break unless response['output'].nil?
    end
    @cs = response['cs']
    response['output']
  end

  def reset
    url = "http://cleverbot.com/getreply?key=#{@api_key}&wrapper=cleverbot_rb"
    response = { 'output' => nil }
    10.times do
      response = RestClient.get(url)
      response = JSON.parse(response)
      break unless response['output'].nil?
    end
    @cs = response['cs']
  end
end
