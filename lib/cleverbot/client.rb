require 'cleverbot/conversation'

module Cleverbot
  # A client that wraps basic API functionality and can maintain
  # multiple conversations associated with an identifier
  # @example Basic conversing
  #   client = Cleverbot::Client.new 'your api key'
  #   puts client.say 'hello' #=> *witty response*
  #   puts client.say 'okay' #=> *another witty response*
  # @example Multiple conversations
  #   client = Cleverbot::Client.new 'your api key'
  #
  #   # Client#say takes an arbitray identifier as a second arguement
  #   # that will start a new conversation with each unique object
  #   # given, and continue that conversation when passed the same identifier.
  #
  #   # Start a new conversation with Mike the symbol
  #   puts client.say('hello', :mike) #=> 'hello'
  #   puts client.say('my name is mike', :mike) #=> 'ok'
  #
  #   # Start a new conversation with Zac the string.
  #   puts client.say('hello', 'Zac') #=> 'hello'
  #   puts client.say('my name is mike', 'Zac') #=> 'no it is zac'
  class Client
    # @return [String] API key used to make requests with this Client
    attr_reader :key

    # @return [Hash<thing, Conversation>] the conversations initiated by this client
    attr_reader :conversations

    # Create a new Client
    # @param key [String] API key
    def initialize(key)
      @key = key
      @conversations = {}
    end

    # @param identifier [thing] identifier to search for
    # @return [Conversation] the conversation associated with this identifier
    def conversation(identifier = :default)
      @conversations[identifier]
    end

    # Say something to the API
    # @param message [String] what to say
    # @param identifier [thing] identifier to associate this converation with
    # @return [String] the response
    def say(message, identifier = :default)
      convo = conversation(identifier) || Conversation.new(key)
      @conversations[identifier] = convo

      convo.reply message
    end

    # Deletes a conversation
    # @param identifier [thing] identifier associated with the conversation
    # @return [Conversation] the removed conversation
    def delete(identifier = :default)
      @conversations.delete identifier
    end
  end
end
