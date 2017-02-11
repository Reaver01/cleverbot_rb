# cleverbot

A Ruby wrapper for the cleverbot.com API.
Adapted from cleverbot.io API for cleverbot.com

## Installation
### Bundler
Add this line to your Gemfile:
```ruby
gem 'cleverbot_rb', git: 'git@github.com:Reaver01/cleverbot_rb.git',
                    branch: 'master'
```

And then execute:
```shell
$ bundle install
```

## Usage
Be sure to look at the actual documentation for the cleverbot.com API when you are not sure about something. Or ask for documentation clarification in the issue tracker here.

Before using this module, please get your API keys at http://www.cleverbot.com/api/.

```ruby
require 'cleverbot'

# Create a new Cleverbot instance, with an optional reference nick set.
CLEVER = Cleverbot.new('api_key')

# Talk with your pal, Cleverbot.
CLEVER.say('Why am I still talking to you?')
# => 'Because you have a beautiful soul.'
```
