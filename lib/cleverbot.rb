require 'httpclient'
require 'json'
require_relative 'cleverbot_errors'

class Cleverbot
  # @return [String] The API Key for the instance.
  attr_reader :api_key

  # Creates a new instance of the Cleverbot.
  # @param api_key [String] The API key for the Cleverbot API.
  def initialize(api_key)
    @api_key = api_key
    @client = HTTPClient.new

    params = {
      key: @api_key
    }
    response = @client.post('http://cleverbot.com/getreply', params).body
    response = JSON.parse(response)
    try_throw(response['errorline'])

    @cs = response['cs']
  end

  # Sends the bot a message and returns its response.
  # @param str [String] The message to send to the bot.
  # @return [String] The bot's response, or its error message.
  def say(str)
    params = {
      key: @api_key,
      text: str,
      cs: @cs
    }
    response = Oj.load(@client.post('http://cleverbot.com/getreply', params).body)
    try_throw(response['errorline'])

    response['response']
  end

  private

  # Throws the relevant errors if possible.
  # @param status [String] The status value from the API
  # @raise [IncorrectCredentialsError] If the api_user and api_key are incorrect.
  # @raise [DuplicatedReferenceNamesError] If the reference name is already in use by the instance.
  def try_throw(errorline)
    case errorline
    when 'Error: API credentials incorrect' then fail Cleverbot::Errors::IncorrectCredentialsError
    when 'Error: reference name already exists' then fail Cleverbot::Errors::DuplicatedReferenceNamesError
    when 'success' then return
    else fail "#{errorline} UNRECOGNIZED ERROR! PLEASE REPORT TO CLEVERBOT RUBY ISSUE TRACKER."
    end
  end
end
