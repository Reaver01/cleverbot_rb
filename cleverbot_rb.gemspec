Gem::Specification.new do |s|
  s.authors = ['Reaver01']
  s.name = 'cleverbot_rb'
  s.summary = 'A Ruby wrapper for the Cleverbot.com web API.'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.description = 'A fully featured wrapper to the Cleverbot.com web API.'
  s.email = 'jawmac@gmail.com'
  s.homepage = 'https://github.com/Reaver01/cleverbot_rb'
  s.metadata = {
    'issue_tracker' => 'https://github.com/Reaver01/cleverbot_rb/issues'
  }
  s.files = [
    'lib/cleverbot.rb'
  ]
  s.add_runtime_dependency('rest-client')
  s.add_runtime_dependency('json')
end
