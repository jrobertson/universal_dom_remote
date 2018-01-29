Gem::Specification.new do |s|
  s.name = 'universal_dom_remote'
  s.version = '0.1.1'
  s.summary = 'Interacts with the web browser via websockets using a ' +
      'SimplePubSub broker. Note: Tested using Firefox.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/universal_dom_remote.rb']
  s.add_runtime_dependency('sps_duplex', '~> 0.1', '>=0.1.0')
  s.signing_key = '../privatekeys/universal_dom_remote.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/universal_dom_remote'
end
