require 'rest-client'
require 'json'

module Cleverbot
  # Wrapper for Cleverbot's REST API
  module API
    # Base API url
    API_URL = 'http://cleverbot.com'.freeze

    # Name of the library
    WRAPPER = 'cleverbot_rb'.freeze

    # The most time to wait to retry for a response
    # from the API in seconds. This is because, at the time of
    # writing, the API will sometimes return an empty response
    # and you must retry your request.
    MAX_BACKOFF = 60

    module_function

    # Executre a GET request.
    # @param route [String] the route to request
    # @param params [Hash] the params to query
    def get_request(route = '', params = {})
      params[:wrapper] = WRAPPER
      response = RestClient.get "#{API_URL}/#{route}", params: params.compact
      JSON.parse response
    end

    # @param key [String] API key
    # @param input [String] the phrase to pass to the conversation
    # @param conversation [String] the conversation ID to pass input to
    # @param retry_empty [true, false] whether to retry if we get an empty response
    # @param backoff [Integer] how long to wait before retrying if retry_empty
    # @return [String] the reply
    def get_reply(key, input, conversation = nil, retry_empty: true, backoff: 1)
      return if backoff > MAX_BACKOFF

      reply = get_request(
        'getreply',
        key: key, input: input, cs: conversation
      )

      return reply unless retry_empty && reply['output'].nil?
      puts "Reponse empty! Retrying after #{backoff} seconds."
      sleep backoff

      get_reply(key, input, conversation, retry_empty: true, backoff: backoff * 2)
    end
  end
end
